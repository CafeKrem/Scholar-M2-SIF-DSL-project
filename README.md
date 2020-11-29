# Scholar-M2-SIF-DSL-project-

## state of the project

### done 
* my language contains all concepts asked.
* interpreter OK , you will see it's a merge of dispatch method and visitor , I discovert dispatch method lately.
* python compiler started but I loose many time with interpreter so I cannot finish it.

there is 3 tests file located in ```org.xtext.example.mydsl.tests```:
* ```MyDslParsingTest.xtend``` containing parsing tests , 27 tests 
* ```MyDslInterpretorTest``` containing interpreting tests , 29 tests
* ```MyDslPythonCompilatorTest``` containing python translated testing 3 tests 

### not done 
I don't suceed to finish those tasks:
* export to CSV
* compiler to JQ 

## project description 

this a scholar projet (in 2nd year of master degree) , in this project we will define a DSL to manipulate JSON data. 

### features 

* Concepts
  * Load, Store JSON files
  * Select subset of objects, Projection (slice of objet)
  * Aka core relational algebra operators
  * Compute basic ∑, ∏ over fields
  * Print field value, #objects, #fields, depth, expressions...
  * Insert/modify/remove object/fields
* Services
  * Export to CSV
  * Interpreter
  * Compilers to (Java|Python|Julia) + JQ (for relevant subset)
  * https://stedolan.github.io/jq/


## usefull link 

https://github.com/FAMILIAR-project/HackOurLanguages-SIF
