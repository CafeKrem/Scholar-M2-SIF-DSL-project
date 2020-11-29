package org.xtext.example.mydsl.generator

import org.xtext.example.mydsl.myDsl.Programme
import org.xtext.example.mydsl.myDsl.Addition
import org.xtext.example.mydsl.myDsl.Assignement
import org.xtext.example.mydsl.myDsl.Boolean
import org.xtext.example.mydsl.myDsl.Div
import org.xtext.example.mydsl.myDsl.JsonArray
import org.xtext.example.mydsl.myDsl.JsonInteger
import org.xtext.example.mydsl.myDsl.JsonObject
import org.xtext.example.mydsl.myDsl.JsonString
import org.xtext.example.mydsl.myDsl.Load
import org.xtext.example.mydsl.myDsl.Save
import org.xtext.example.mydsl.myDsl.Minus
import org.xtext.example.mydsl.myDsl.Prod
import org.xtext.example.mydsl.myDsl.Sum
import org.xtext.example.mydsl.myDsl.Variable
import org.xtext.example.mydsl.myDsl.Statement
import java.util.Hashtable
import org.xtext.example.mydsl.myDsl.JsonValue
import org.xtext.example.mydsl.myDsl.Association
import org.xtext.example.mydsl.myDsl.Time
import org.xtext.example.mydsl.myDsl.BinaryExpression
import org.xtext.example.mydsl.myDsl.And
import org.xtext.example.mydsl.myDsl.Or
import org.xtext.example.mydsl.myDsl.False
import org.xtext.example.mydsl.myDsl.True
import java.util.Dictionary
import java.util.ArrayList
import jdk.nashorn.internal.parser.JSONParser
//import org.json.JSONObject
import java.io.File
import java.io.FileReader
import java.io.BufferedReader
import org.codehaus.jackson.map.ObjectMapper
import java.util.Map
import org.codehaus.jackson.type.TypeReference
import java.io.FileWriter
import java.util.Iterator
import java.util.List
import org.xtext.example.mydsl.myDsl.Depth
import org.xtext.example.mydsl.myDsl.Print

class MyDslInterpretor extends MyDslVisitor<Object> {

	Memory mem
	private FileWriter logFile
	private String fileName

	new(String fileName) {
		mem = new Memory()
		this.fileName = fileName
	}

	override visitProgramme(Programme programme) {
		var Object res = null
		for (Statement stament : programme.statements) {
			res = stament.accept(this)
		}
		return res

	}

	def dispatch operation(Addition addition, int left, int right) {
		return left + right
	}

	def dispatch operation(Div div, int left, int right) {
		return left / right
	}

	def dispatch operation(Minus minus, int left, int right) {
		return left - right
	}

	def dispatch operation(Time time, int left, int right) {
		return left * right
	}

	def dispatch operation(And and, boolean left, boolean right) {
		return left && right
	}

	def dispatch operation(Or or, boolean left, boolean right) {
		return left || right
	}

	override visitBinaryExpression(BinaryExpression expression) {
		var left = expression.left.accept(this)
		var right = expression.right.accept(this)
		return expression.op.operation(left, right)

	}

	override visitAddition(Addition addition) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitAssignement(Assignement assignement) {
		var exprResult = assignement.getValue().accept(this)
		if (assignement.variable.nodes.size == 1) {
			mem.setAt(assignement.variable.nodes.get(0), exprResult)
		} else {

			var iterator = assignement.variable.nodes.iterator()
			var stringtmp = ""
			var JSONValueToModiefied = mem.lookUp(iterator.next())
			while (iterator.hasNext()) {
				stringtmp = iterator.next()
				if (!iterator.hasNext()) {
					put(JSONValueToModiefied, stringtmp, exprResult)
				}
				JSONValueToModiefied = (JSONValueToModiefied as Map<String, JsonValue>).get(stringtmp)
			}
		}

		return exprResult
	}

	def dispatch put(Map<String, Object> object, String string, Object value) {
		object.put(string, value)
	}

	def dispatch put(ArrayList<Object> object, String string, Object value) {
		object.set(Integer.parseInt(string), value)
	}

	override visitAssociation(Association asso) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitDiv(Div div) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitJsonArray(JsonArray array) {
		var a = new ArrayList()
		for (JsonValue jValue : array.value) {
			a.add(jValue.accept(this))
		}
		return a
	}

	override visitJsonInteger(JsonInteger integer) {
		return integer.value
	}

	override visitJsonObject(JsonObject object) {
		val Dictionary<String, Object> dictionary = new Hashtable()
		for (Association association : object.associations) {
			dictionary.put(association.key, association.value.accept(this))
		}
		return dictionary
	}

	override visitJsonString(JsonString string) {
		return string.value
	}

	override visitLoad(Load load) {

		val File file = new File(load.path);
		val FileReader fileReader = new FileReader(file);
		val BufferedReader bufferedReader = new BufferedReader(fileReader);
		val StringBuilder stringBuilder = new StringBuilder();
		var String line = bufferedReader.readLine();
		while (line != null) {
			stringBuilder.append(line).append("\n");
			line = bufferedReader.readLine();
		}
		bufferedReader.close(); // This responce will have Json Format String
		val String responce = stringBuilder.toString();
		var Map<String, JsonValue> jsonObject = new ObjectMapper().readValue(responce,
			new TypeReference<Map<String, Object>>() {
			}) as Map<String, JsonValue>
		mem.setAt(load.varName, jsonObject)
		return jsonObject
	}

	override visitSave(Save saveModel) {
		var FileWriter myWriter = new FileWriter(saveModel.path);
		// var JsonValue memLookUp = mem.lookUp(saveModel.varName) as JsonValue
		var memLookUp = mem.lookUp(saveModel.varName)
		save(myWriter, memLookUp)
		myWriter.close()
		return memLookUp
	}

	def dispatch save(FileWriter writer, Map object) {
		writer.write("{")
		var Iterator ite = object.entrySet().iterator()
		while (ite.hasNext()) {
			var Map.Entry<String, Object> entry = ite.next() as Map.Entry
			writer.write("\"")
			writer.write(entry.getKey())
			writer.write("\"")
			writer.write(":")
			var class = entry.value.getClass()
			save(writer, entry.value)
			if (ite.hasNext()) {
				writer.write(",")
			}
		}
		writer.write("}")
	}

	def dispatch save(FileWriter writer, Integer integer) {
		writer.write(integer.toString())
	}

	def dispatch save(FileWriter writer, String string) {
		writer.write("\"")
		writer.write(string.toString())
		writer.write("\"")
	}

	def dispatch save(FileWriter writer, java.lang.Boolean bool) {

		writer.write(bool.booleanValue().toString())
	}

	def dispatch save(FileWriter writer, True bool) {
		writer.write("true")
	}

	def dispatch save(FileWriter writer, False bool) {
		writer.write("false")
	}

	def dispatch save(FileWriter writer, List array) {
		writer.write("[")
		var Iterator ite = array.iterator()
		while (ite.hasNext) {
			save(writer, ite.next())
			if (ite.hasNext()) {
				writer.write(",")
			}
		}
		writer.write("]")
	}

	override visitMinus(Minus minus) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitProd(Prod prod) {
		return prod(prod.variable.accept(this))
	}

	override visitSum(Sum sum) {
		return sum(sum.variable.accept(this))
	}

	def dispatch prod(List<Integer> l) {
		var accu = 1
		for (i : l) {
			accu *= i
		}
		return accu
	}

	def dispatch prod(Object l) {
		throw new UnsupportedOperationException("only array can be acepted")
	}

	def dispatch sum(List<Integer> l) {
		var accu = 0
		for (i : l) {
			accu += i
		}
		return accu
	}

	def dispatch sum(Object l) {
		throw new UnsupportedOperationException("only array can be acepted")
	}

	override visitVariable(Variable variable) {
		if (variable.nodes.size == 1) {
			return mem.lookUp(variable.nodes.get(0))
		} else {
			var iterator = variable.nodes.iterator()
			var stringtmp = ""
			var jsonValue = mem.lookUp(iterator.next())
			while (iterator.hasNext()) {
				stringtmp = iterator.next()
				jsonValue = (jsonValue as Map).get(stringtmp)
			}
			return jsonValue
		}
	}

	override visitBoolean(Boolean bool) {
		return evalBoolean(bool)
	}

	def dispatch evalBoolean(True bool) {
		return true
	}

	def dispatch evalBoolean(False bool) {
		return false
	}

	override visitDepth(Depth depth) {
		depth(depth.value.accept(this))
	}

	def dispatch depth(List l) {
		var int depth = 1
		var int max = 0
		for (Object i : l) {
			max = Math.max(max, depth(i) as Integer)
		}
		return depth + max
	}

	def dispatch depth(Map<String, Object> m) {
		var int depth = 1
		var int max = 0
		for (Map.Entry i : m.entrySet()) {
			max = Math.max(max, depth(i.getValue()) as Integer)
		}
		return depth + max
	}

	def dispatch depth(Object o) {
		return 1
	}

	override visitPrint(Print p) {
		logFile = new FileWriter(fileName)
		print(p.value.accept(this))
		logFile.close()
		return null
	}

	def dispatch print(int i) {
		logFile.write(i.toString())
	}

	def dispatch print(String s) {
		logFile.write(s.toString())
	}

	def dispatch print(List l) {
		logFile.write(l.toString())
	}

	def dispatch print(Map m) {
		logFile.write(m.toString())
	}

}
