package;

using StringTools;

class SimpleMathParser {
    public static function parse(input:String):Float {
        input = input.trim();
        if (input.startsWith("sqrt:")) {
            var inner = input.substr("sqrt:".length).trim();
            var firstNumber = "";
            var i = 0;

            // Extract the first number
            while (i < inner.length) {
                var ch = inner.charAt(i);
                if ("0123456789.".indexOf(ch) != -1 || (ch == "-" && i == 0)) {
                    firstNumber += ch;
                    i++;
                } else {
                    break;
                }
            }

            var rest = inner.substr(i).trim();
            var sqrtValue = Math.sqrt(Std.parseFloat(firstNumber));
            var newExpr = Std.string(sqrtValue) + " " + rest;
            return evaluateBasic(newExpr);
        }

        input = input.replace("pi", Std.string(Math.PI));
        return evaluateBasic(input);
    }

    // Evaluate simple math expressions like "4 * 3 + 2 / 1.5"
    static function evaluateBasic(expr:String):Float {
        try {
            var tokens = tokenize(expr);
            return evaluateTokens(tokens);
        } catch (e:Dynamic) {
            trace("Error: " + e);
            return Math.NaN;
        }
    }

    static function tokenize(expr:String):Array<String> {
        var tokens:Array<String> = [];
        var number = "";
        for (i in 0...expr.length) {
            var ch = expr.charAt(i);
            if (ch == " ") continue;

            if ("0123456789.".indexOf(ch) != -1 || (ch == "-" && (i == 0 || "+-*/(".indexOf(expr.charAt(i - 1)) != -1))) {
                number += ch;
            } else {
                if (number != "") {
                    tokens.push(number);
                    number = "";
                }
                tokens.push(ch);
            }
        }
        if (number != "") tokens.push(number);
        return tokens;
    }

    static function evaluateTokens(tokens:Array<String>):Float {
        var values:Array<Float> = [];
        var ops:Array<String> = [];

        function applyOp() {
            var b = values.pop();
            var a = values.pop();
            var op = ops.pop();
            switch (op) {
                case "+": values.push(a + b);
                case "-": values.push(a - b);
                case "*": values.push(a * b);
                case "/": values.push(a / b);
            }
        }

        var precedence = function(op:String):Int {
            return switch(op) {
                case "+", "-": 1;
                case "*", "/": 2;
                default: 0;
            };
        }

        for (token in tokens) {
            if (~/^-?\d+(\.\d+)?$/.match(token)) {
                values.push(Std.parseFloat(token));
            } else if ("+-*/".indexOf(token) != -1) {
                while (ops.length > 0 && precedence(ops[ops.length - 1]) >= precedence(token)) {
                    applyOp();
                }
                ops.push(token);
            }
        }

        while (ops.length > 0) {
            applyOp();
        }

        return values.length > 0 ? values[0] : Math.NaN;
    }
}
