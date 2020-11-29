package org.xtext.example.mydsl.generator

import org.xtext.example.mydsl.generator.MyDslVisitor
import org.xtext.example.mydsl.myDsl.Print
import org.xtext.example.mydsl.myDsl.Depth
import org.xtext.example.mydsl.myDsl.BinaryExpression
import org.xtext.example.mydsl.myDsl.Programme
import org.xtext.example.mydsl.myDsl.Addition
import org.xtext.example.mydsl.myDsl.Assignement
import org.xtext.example.mydsl.myDsl.Association
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
import java.io.File
import java.io.FileWriter
import org.xtext.example.mydsl.myDsl.Statement
import java.io.BufferedWriter
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl
import java.util.Dictionary
import java.util.Iterator
import org.xtext.example.mydsl.myDsl.JsonValue
import java.util.Hashtable
import org.xtext.example.mydsl.myDsl.Expression

class MyDslPythonCompilator extends MyDslVisitor<Object> {

	var FileWriter pythonFile
	var MEMORYFILELOCATION = "jsonMem.py"

	new(String pythonFileName) {
		pythonFile = new FileWriter(pythonFileName)

	}

	override visitPrint(Print p) {
		pythonFile.write("print(" + string(p.value) + ")\n")
		return null
	}

	def dispatch string(JsonArray l) {
		var str = "["
		var ite = l.value.iterator()
		while (ite.hasNext()) {
			var tmp = ite.next()
			str += string(tmp)
			if (ite.hasNext()) {
				str += " , "
			}
		}
		str += "]"
		return str
	}

	def dispatch string(Variable v) {
		var str = "\""
		var ite = v.nodes.iterator()
		while (ite.hasNext()) {
			var tmp = ite.next()
			str += tmp
			if (ite.hasNext()) {
				str += "."
			}
		}
		str += "\""
		return "jm.jsonMemory[" + str + "]"
	}

	def dispatch string(JsonObject o) {
		var str = "{"
		var ite = o.associations.iterator()
		while (ite.hasNext()) {
			var tmp = ite.next()
			str += "\"" + tmp.key + "\" : " + string(tmp.value)
			if (ite.hasNext()) {
				str += " , "
			}
		}
		str += "}"
		return str
	}

	def dispatch string(JsonString s) {
		return "\"" + s.value + "\""
	}

	def dispatch string(JsonInteger i) {
		return "" + i.value
	}

	def dispatch string(Boolean b) {
	}

	def dispatch string(Expression e) {}

	override visitDepth(Depth depth) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitBinaryExpression(BinaryExpression expression) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitProgramme(Programme programme) {
		var Object res = null
		this.writeMemory()
		this.writeImport()
		for (Statement stament : programme.statements) {
			res = stament.accept(this)
		}
		pythonFile.flush();
		pythonFile.close()
		return res
	}

	def writeImport() {
		pythonFile.write("import jsonMem as jm\n")
		pythonFile.write("import json\n")
	}

	def writeMemory() {
		var BufferedWriter writer = new BufferedWriter(new FileWriter(MEMORYFILELOCATION, false))
		writer.append("jsonMemory = dict()\n")
		writer.close();
	}

	override visitAddition(Addition addition) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitAssignement(Assignement assignement) {
		if (assignement.variable.nodes.size == 1) {
			pythonFile.write("jm.jsonMemory[" + "\"" + assignement.variable.nodes.get(0).toString() + "\"" + "] =")
			assignement.getValue().accept(this)
			pythonFile.write("\n")
		} else {
			throw new UnsupportedOperationException("")
		}
		return null
	}

	override visitAssociation(Association asso) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitBoolean(Boolean bool) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitDiv(Div div) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitJsonArray(JsonArray array) {
		pythonFile.write(string(array) + "\n")
		return null
	}

	override visitJsonInteger(JsonInteger integer) {
		pythonFile.write(string(integer) + "\n")
		return null
	}

	override visitJsonObject(JsonObject object) {
		pythonFile.write(string(object))
		return null
	}

	override visitJsonString(JsonString string) {
		pythonFile.write(string(string) + "\n")
		return null
	}

	override visitLoad(Load load) {
		pythonFile.write("j = open(\"" + load.path + "\" , \"r\")\n")
		pythonFile.write("jm.jsonMemory[\"" + load.varName.toString() + "\"] = json.loads( j )\n")
		pythonFile.write("j.close()\n")
		return null
	}

	override visitSave(Save save) {
		var str = "f = open(\"" + save.path + "\" , \"w+\")\n"
		pythonFile.write(str)
		str = "print(" + "jm.jsonMemory[\"" + save.varName + "\"] , file=f )\n"
		pythonFile.write(str)
		pythonFile.write("f.close()\n")
		return null
	}

	override visitMinus(Minus minus) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitProd(Prod prod) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitSum(Sum sum) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override visitVariable(Variable variable) {
		if (variable.nodes.size == 1) {
			pythonFile.write("jm.jsonMemory[\"" + variable.nodes.get(0).toString() + "]\"\n")
		} else {
			throw new UnsupportedOperationException("TODO: auto-generated method stub")
		}
		return null
	}

}
