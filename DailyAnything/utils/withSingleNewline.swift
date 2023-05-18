// Takes a string, returns that string with one and only one trailing newline
func withSingleNewline(_ str: String) -> String {
    var result = str.trimmingCharacters(in: .whitespacesAndNewlines)
    
    result.append("\n")
    
    return result
}
