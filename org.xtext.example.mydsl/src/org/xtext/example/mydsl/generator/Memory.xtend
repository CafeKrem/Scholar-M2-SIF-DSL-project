package org.xtext.example.mydsl.generator

import org.xtext.example.mydsl.myDsl.JsonValue
import java.util.Hashtable
import java.util.Dictionary
import java.util.Map

class Memory {
	Map VariableMemory = new Hashtable()
	
	def Map getVariableMemory() {
		return VariableMemory
	}

	def lookUp(String varName) {
		val value = VariableMemory.get(varName)
		if (value == null) {
			throw new InterpretorException("variable " + varName + " is not defined")
		}
		return value
	}

	def void setAt(Object varName, Object value) {
		VariableMemory.put(varName, value)
	}
}
