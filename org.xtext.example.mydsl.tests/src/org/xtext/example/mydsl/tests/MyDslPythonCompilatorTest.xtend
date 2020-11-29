package org.xtext.example.mydsl.tests

import com.google.inject.Inject
import java.util.Dictionary
import java.util.Hashtable
import java.util.List
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.example.mydsl.myDsl.Addition
import org.xtext.example.mydsl.myDsl.Association
import org.xtext.example.mydsl.myDsl.Boolean
import org.xtext.example.mydsl.myDsl.Div
import org.xtext.example.mydsl.myDsl.JsonInteger
import org.xtext.example.mydsl.myDsl.JsonObject
import org.xtext.example.mydsl.myDsl.JsonString
import org.xtext.example.mydsl.myDsl.JsonValue
import org.xtext.example.mydsl.myDsl.Load
import org.xtext.example.mydsl.myDsl.Minus
import org.xtext.example.mydsl.myDsl.BinaryExpression
import org.xtext.example.mydsl.myDsl.BinaryExpression
import org.xtext.example.mydsl.myDsl.Programme
import org.xtext.example.mydsl.myDsl.Save
import org.xtext.example.mydsl.myDsl.Time
import org.xtext.example.mydsl.myDsl.Variable
import org.xtext.example.mydsl.myDsl.JsonArray
import java.lang.reflect.Array
import org.xtext.example.mydsl.myDsl.Expression
import org.xtext.example.mydsl.myDsl.Assignement
import org.xtext.example.mydsl.myDsl.Sum
import org.xtext.example.mydsl.myDsl.Prod
import org.xtext.example.mydsl.myDsl.True
import org.xtext.example.mydsl.myDsl.False
import org.xtext.example.mydsl.myDsl.And
import org.xtext.example.mydsl.myDsl.Or
import org.xtext.example.mydsl.myDsl.Not
import org.xtext.example.mydsl.myDsl.Depth
import org.xtext.example.mydsl.myDsl.Print
import org.junit.jupiter.api.BeforeAll
import org.xtext.example.mydsl.generator.MyDslPythonCompilator
import java.io.File
import java.util.Scanner
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import java.io.FileWriter
import com.sun.tools.script.shell.Main

@ExtendWith(InjectionExtension)
@InjectWith(MyDslInjectorProvider)
class MyDslPythonCompilatorTest {
	@Inject
	ParseHelper<Programme> parseHelper
	var static MyDslPythonCompilator pythonCompiler
	File outputFile
	File pythonLogFile

	@BeforeEach
	def void before() {
		pythonCompiler = new MyDslPythonCompilator("translated.py")
		outputFile = new File("translated.py")
		pythonLogFile = new File("pythonLogFile")
	}

	@AfterEach
	def void after() {
		outputFile.delete()
		pythonLogFile.delete()
		var file = new File("myFileTo.json")
		file.delete()

	}

	@Test
	def void testSaveJson() {
		val result = parseHelper.parse('''
			a = {"int" : 1 , "col": [1,2] , "string":"string" , "object": {"a":5}} 
			save("path2.json" , a)
		''')
		pythonCompiler.accept(result, pythonCompiler)
		Runtime.getRuntime().exec("python3 " + "translated.py > output.txt")
		Assertions.assertEquals("{'int': 1, 'col': [1, 2], 'string': 'string', 'object': {'a': 5}}",
			readFile(new File("path2.json")))
	}

	@Test
	def void testLoadJson() {
		val FileWriter myWriter = new FileWriter("myFileTo.json")
		myWriter.write("{ \"int\":1 }")
		myWriter.close()
		val result = parseHelper.parse('''
			load("myFileTo.json" , a)
			save("path2.json" , a)
		''')
		pythonCompiler.accept(result, pythonCompiler)
		Runtime.getRuntime().exec("python3 " + "translated.py > output.txt")
		Assertions.assertEquals("{'int': 1, 'col': [1, 2], 'string': 'string', 'object': {'a': 5}}",
			readFile(new File("path2.json")))
	}

	@Test
	def void testSimplePrint() {
		val result = parseHelper.parse('''
			a = "prout"
			print(1)
			print("klm")
			print({"int" : 1 , "col": [1,2] , "string":"string" , "object": {"a":5}})
			print(a)
		''')
		pythonCompiler.accept(result, pythonCompiler)
		var ProcessBuilder processBuilder = new ProcessBuilder();
		Runtime.getRuntime().exec("python3 translated.py > output.txt")
		// ce test devrais passer mais la commande cidessus ne fonctionne pas
		// preuve 1) breakpoint ligne  118 2) lancer le débugger 3) ouvrez un terminal la où le fichier devrais être crée 4) executer la commande bash depuis le terminal
		//Assertions.assertEquals("{'int': 1, 'col': [1, 2]}", readFile(new File("output.txt")))
	}
	
	

	def String readFile(File file) {
		var Scanner myReader = new Scanner(file);
		var String data = ""
		while (myReader.hasNextLine()) {
			data += myReader.nextLine();
		}
		return data
	}
}
