package hx.ws;

class HttpResponse {
    public var httpVersion:String = "HTTP/1.1";
    public var code:Int = -1;
    public var text:String = "";

    public var headers:Map<String, String> = new Map<String, String>();

    public function new() {
    }

    public function addLine(line:String) {
        if (code == -1) {
            var parts = line.split(" ");
            httpVersion = parts[0];
            code = Std.parseInt(parts[1]);
            text = parts[2];
        } else {
            var n = line.indexOf(":");
            var name = line.substr(0, n);
            var value = line.substr(n + 1, line.length);
            headers.set(StringTools.trim(name), StringTools.trim(value));
        }
    }

    public function build():String {
        var sb:StringBuf = new StringBuf();

        sb.add(httpVersion);
        sb.add(" ");
        sb.add(code);
        if (text != "") {
            sb.add(" ");
            sb.add(text);
        }
        sb.add("\r\n");

        var hasHeaders = false;
        for (header in headers.keys()) {
            hasHeaders = true;
            sb.add(header);
            sb.add(": ");
            sb.add(headers.get(header));
            sb.add("\r\n");
        }

        if (hasHeaders == false) {
            sb.add("\r\n");
        }
        return sb.toString();
    }

    public function toString():String {
        return build();
    }
}
