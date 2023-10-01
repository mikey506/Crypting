; Usage: /asciitoternary <text>
;        /ternarytoascii <text>
;        /caesarencode <-1|0|1> <text>
;        /caesardecode <-1|0|1> <text>

alias asciitoternary {
  var %input = $1-
  var %ternary = ""
  var %i
  var %char
  for %i 1 $len(%input) {
    %char = $asc(%input,%i)
    %ternary = %ternary $base(%char,10,3)
  }
  return %ternary
}

alias ternarytoascii {
  var %input = $1-
  var %ascii = ""
  var %i
  var %char
  for %i 1 $len(%input) 3 {
    %char = $base($mid(%input,%i,3),3,10)
    %ascii = %ascii $chr(%char)
  }
  return %ascii
}

alias caesarencode {
  var %shift = $1
  var %input = $2-
  var %output = ""
  var %i
  var %char
  for %i 1 $len(%input) {
    %char = $asc(%input,%i)
    if (%char >= 65 && %char <= 90) {
      %char = $calc((%char - 65 + %shift) % 26 + 65)
    }
    elseif (%char >= 97 && %char <= 122) {
      %char = $calc((%char - 97 + %shift) % 26 + 97)
    }
    %output = %output $chr(%char)
  }
  return %output
}

alias caesardecode {
  var %shift = $1
  var %input = $2-
  var %output = ""
  var %i
  var %char
  for %i 1 $len(%input) {
    %char = $asc(%input,%i)
    if (%char >= 65 && %char <= 90) {
      %char = $calc((%char - 65 - %shift + 26) % 26 + 65)
    }
    elseif (%char >= 97 && %char <= 122) {
      %char = $calc((%char - 97 - %shift + 26) % 26 + 97)
    }
    %output = %output $chr(%char)
  }
  return %output
}
