package org.xtext.example.mydsl.tests

import com.google.inject.Inject
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.extensions.InjectionExtension
import org.eclipse.xtext.testing.util.ParseHelper
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.^extension.ExtendWith
import org.xtext.example.mydsl.generator.MyDslInterpretor
import org.xtext.example.mydsl.myDsl.Programme
import org.junit.BeforeClass
import com.google.inject.Inject
import org.xtext.example.mydsl.generator.OperationNotPermited
import java.util.ArrayList
import java.util.HashMap
import java.util.Dictionary
import org.xtext.example.mydsl.myDsl.JsonValue
import java.io.File
import java.io.FileWriter
import org.json.JSONObject
import java.util.Map
import org.junit.AfterClass
import org.junit.After
import java.util.Scanner
import org.junit.Before
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.AfterEach

@ExtendWith(InjectionExtension)
@InjectWith(MyDslInjectorProvider)
class MyDslInterpretorTest {
	@Inject
	ParseHelper<Programme> parseHelper

	static MyDslInterpretor visitor
	File logFile

	@BeforeAll
	def static void beforeClass() {
		visitor = new MyDslInterpretor("logFile.log")

	}

	@BeforeEach
	def void before() {
		logFile = new File("logFile.log")
	}

	@AfterEach
	def void after() {
		logFile.delete()
	}

	@Test
	def void testConst() {
		val result = parseHelper.parse('''
			1
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 1)
	}

	@Test
	def void testDefineVariable() {
		val result = parseHelper.parse('''
			a = 5
			a
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 5)
	}

	@Test
	def void testMultipleAssignement() {
		val result = parseHelper.parse('''
			a = 5
			b = 2
			a
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 5)
	}

	@Test
	def void testBooleanExpression() {
		val result = parseHelper.parse('''
			a = true
			a 
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), true)
	}

	@Test
	def void testFalseBooleanExpression() {
		val result = parseHelper.parse('''
			false 
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), false)
	}

	@Test
	def void testSimpleString() {
		val result = parseHelper.parse('''
			"Arthas"
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), "Arthas")
	}

	@Test
	def void testSimpleStringAssignement() {
		val result = parseHelper.parse('''
			a = "Thrall"
			a
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), "Thrall")
	}

	@Test
	def void testWrongOperationOnString() {
		val result = parseHelper.parse('''
			"Patrick" * 2 
		''')
		try {
			visitor.accept(result, visitor)
			Assertions.fail()
		} catch (IllegalArgumentException e) {
		}

	}

	@Test
	def void testJsonObject() {
		val result = parseHelper.parse('''
			{ "int" : 1 , "string": "whosyourdaddy" , "json": {"string": "thereisnospoon"} , "array": [1 , 2] , "boolena" : true } 
		''')
		val array = new ArrayList()
		array.add(1)
		array.add(2)
		val Dictionary<String, Object> dictionary = visitor.accept(result, visitor) as Dictionary<String, Object>
		Assertions.assertEquals(dictionary.get("int"), 1)
		Assertions.assertEquals(dictionary.get("string"), "whosyourdaddy")
		Assertions.assertEquals((dictionary.get("json") as Dictionary<String, Object> ).get("string"), "thereisnospoon")
		Assertions.assertArrayEquals(dictionary.get("array") as ArrayList, array)
	}

	@Test
	def void testLoadJsonFile() {
		val FileWriter myWriter = new FileWriter("myFileTo.json")
		myWriter.write("{ \"int\":1 }")
		myWriter.close()
		val result = parseHelper.parse('''
			load("myFileTo.json", a)
			a
		''')
		val Map dictionary = visitor.accept(result, visitor) as Map<String, JsonValue>
		Assertions.assertEquals(dictionary.get('int'), 1)
	}

	@Test
	def void testModifJSONField() {
		val result = parseHelper.parse('''
			a = { "int" : 1 } 
			a.int = 5
			a
		''')
		var resultInterpret = visitor.accept(result, visitor) as Map<String, JsonValue>
		Assertions.assertEquals(resultInterpret.get("int"), 5)
	}

	@Test
	def void testSimpleAddition() {
		val result = parseHelper.parse('''
			1 + 3 
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 4)
	}

	@Test
	def void testSimpleTime() {
		val result = parseHelper.parse('''
			2 * 3 
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 6)
	}

	@Test
	def void testSimpleMinus() {
		val result = parseHelper.parse('''
			3 - 3 
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 0)
	}

	@Test
	def void testComplexAlgebricOperation() {
		val result = parseHelper.parse('''
			(( 1 + 3 ) * 2 ) / 1 
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 8)
	}

	@Test
	def void testBinOpWithVariable() {
		val result = parseHelper.parse('''
			a = 5
		''')
		Assertions.assertEquals(visitor.accept(result, visitor), 5)
	}

	@Test
	def void testSaveJson() {
		val result = parseHelper.parse('''
			a = { "int" : 1 , "string": "whosyourdaddy" , "json": {"string": "thereisnospoon"} , "array": [1 , 2] , "boolena" : true } 
			save("file.json" , a)
			load("file.json" , b)
			b		 
		''')
		val array = new ArrayList()
		array.add(1)
		array.add(2)
		val Map dictionary = visitor.accept(result, visitor) as Map
		Assertions.assertEquals(dictionary.get("int"), 1)
		Assertions.assertEquals(dictionary.get("string"), "whosyourdaddy")
		Assertions.assertEquals((dictionary.get("json") as Map).get("string"), "thereisnospoon")
		Assertions.assertArrayEquals(dictionary.get("array") as ArrayList, array)
	}

	@Test
	def void testSum() {
		val result = parseHelper.parse('''
			a = [1 , 2 , 3 , 4 ,5 ]
			sum(a) 
		''')
		var resultExpr = visitor.accept(result, visitor)
		Assertions.assertEquals(resultExpr, 15)
	}

	@Test
	def void testSumInObject() {
		val result = parseHelper.parse('''
			a = {"col":[1 , 2 , 3 , 4 ,5 ]}
			sum(a.col) 
		''')
		var resultExpr = visitor.accept(result, visitor)
		Assertions.assertEquals(resultExpr, 15)
	}

	@Test
	def void testSumError() {
		val result = parseHelper.parse('''
			a = {"int" : 1 } 
			sum(a.int) 
		''')
		try {
			var resultExpr = visitor.accept(result, visitor)
			Assertions.fail()
		} catch (Exception e) {
		}
	}

	def void testProd() {
		val result = parseHelper.parse('''
			a = [1 , 2 , 3 , 4 ,5 ]
			prod(a) 
		''')
		var resultExpr = visitor.accept(result, visitor)
		Assertions.assertEquals(resultExpr, 120)
	}

	@Test
	def void testProdInObject() {
		val result = parseHelper.parse('''
			a = {"col":[1 , 2 , 3 , 4 ,5 ]}
			prod(a.col) 
		''')
		var resultExpr = visitor.accept(result, visitor)
		Assertions.assertEquals(resultExpr, 120)
	}

	@Test
	def void testProdError() {
		val result = parseHelper.parse('''
			a = {"int" : 1 } 
			prod(a.int) 
		''')
		try {
			var resultExpr = visitor.accept(result, visitor)
			Assertions.fail()
		} catch (Exception e) {
		}
	}

	@Test
	def void testDepth() {
		val result = parseHelper.parse('''
			a = {}
			depth ( a ) 
		''')
		val resultInterpret = visitor.accept(result, visitor)
		Assertions.assertEquals(resultInterpret, 1)
	}

	@Test
	def void testDepth2() {
		val result = parseHelper.parse('''
			a = {  "Person": {     "Name": "Homer", "Age": 39,"Hobbies": ["Eating", "Sleeping"]  }
			 }
			depth ( a ) 
		''')
		val resultInterpret = visitor.accept(result, visitor)
		Assertions.assertEquals(resultInterpret, 4)
	}

	@Test
	def void testDepth3() {
		val result = parseHelper.parse('''
			a = []
			depth(a)
		''')
		val resultInterpret = visitor.accept(result, visitor)
		Assertions.assertEquals(resultInterpret, 1)
	}

	@Test
	def void testPrint() {
		val result = parseHelper.parse('''
			print("string")
		''')

		val resultInterpret = visitor.accept(result, visitor)
		var Scanner myReader = new Scanner(logFile);
		var String data = ""
		while (myReader.hasNextLine()) {
			data += myReader.nextLine();
		}
		Assertions.assertEquals(data, "string")
	}

	@Test
	def void testPrintArray() {
		val result = parseHelper.parse('''
			print([1 , 2 , 3 , 4 ,5])
		''')

		val resultInterpret = visitor.accept(result, visitor)
		var Scanner myReader = new Scanner(logFile);
		var String data = ""
		while (myReader.hasNextLine()) {
			data += myReader.nextLine();
		}
		Assertions.assertEquals("[1, 2, 3, 4, 5]", data)
	}

	@Test
	def void testPrintInt() {
		val result = parseHelper.parse('''
			print(1)
		''')

		val resultInterpret = visitor.accept(result, visitor)
		var Scanner myReader = new Scanner(logFile);
		var String data = ""
		while (myReader.hasNextLine()) {
			data += myReader.nextLine();
		}
		Assertions.assertEquals("1", data)
	}

	@Test
	def void testPrintObject() {
		val result = parseHelper.parse('''
			a = { "int" : 1 , "string": "whosyourdaddy" , "json": {"string": "thereisnospoon"} , "array": [1 , 2] , "boolena" : true } 
						
				print(a)
		''')

		val resultInterpret = visitor.accept(result, visitor)
		var Scanner myReader = new Scanner(logFile);
		var String data = ""
		while (myReader.hasNextLine()) {
			data += myReader.nextLine();
		}
		Assertions.assertEquals(
			"{int=1, string=whosyourdaddy, json={string=thereisnospoon}, boolena=true, array=[1, 2]}", data)
	}
}
