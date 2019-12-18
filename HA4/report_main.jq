jsoniq version "3.0";
import module namespace im= "reportForStudent.jq";
import module namespace file = "http://expath.org/ns/file";


let $studentOut := parse-json(file:read-text("testDBs/answers.json"))
let $correctOut := parse-json(file:read-text("testDBs/correct_answers.json"))
return im:reportForStudent($studentOut,$correctOut)
