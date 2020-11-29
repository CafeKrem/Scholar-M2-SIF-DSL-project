package org.xtext.example.mydsl.generator

import org.xtext.example.mydsl.myDsl.Addition
import org.xtext.example.mydsl.myDsl.Assignement
import org.xtext.example.mydsl.myDsl.Boolean
import org.xtext.example.mydsl.myDsl.Div
import org.xtext.example.mydsl.myDsl.JsonArray
import org.xtext.example.mydsl.myDsl.JsonInteger
import org.xtext.example.mydsl.myDsl.JsonObject
import org.xtext.example.mydsl.myDsl.JsonString
import org.xtext.example.mydsl.myDsl.Load
import org.xtext.example.mydsl.myDsl.Minus
import org.xtext.example.mydsl.myDsl.Prod
import org.xtext.example.mydsl.myDsl.Programme
import org.xtext.example.mydsl.myDsl.Save
import org.xtext.example.mydsl.myDsl.Sum
import org.xtext.example.mydsl.myDsl.Variable
import org.xtext.example.mydsl.myDsl.Association
import org.xtext.example.mydsl.myDsl.BinaryExpression
import org.xtext.example.mydsl.myDsl.True
import org.xtext.example.mydsl.myDsl.False
import org.xtext.example.mydsl.myDsl.Depth
import org.xtext.example.mydsl.myDsl.Print

abstract class MyDslVisitor<T> {

	def dispatch accept(Print p, MyDslVisitor<T> visitor) {
		visitor.visitPrint(p)
	}

	def T visitPrint(Print p)

	def dispatch accept(Depth d, MyDslVisitor<T> visitor) {
		visitor.visitDepth(d)
	}

	def T visitDepth(Depth depth)

	def dispatch accept(Addition a, MyDslVisitor<T> visitor) {
		visitor.visitAddition(a)
	}

	def dispatch accept(BinaryExpression binOp, MyDslVisitor<T> visitor) {
		visitor.visitBinaryExpression(binOp)
	}

	def T visitBinaryExpression(BinaryExpression expression)

	def dispatch accept(Programme p, MyDslVisitor<T> visitor) {
		visitor.visitProgramme(p)
	}

	def T visitProgramme(Programme programme)

	def T visitAddition(Addition addition)

	def dispatch accept(Association asso, MyDslVisitor<T> visitor) {
		visitor.visitAssociation(asso)
	}

	def dispatch accept(Assignement assign, MyDslVisitor<T> visitor) {
		visitor.visitAssignement(assign)
	}

	def T visitAssignement(Assignement assignement)

	def T visitAssociation(Association asso)

	def dispatch accept(Boolean bool, MyDslVisitor<T> visitor) {
		visitor.visitBoolean(bool)
	}

	def T visitBoolean(Boolean bool)

	def dispatch accept(Div d, MyDslVisitor<T> visitor) {
		visitor.visitDiv(d)
	}

	def T visitDiv(Div div)

	def dispatch accept(JsonArray jArray, MyDslVisitor<T> visitor) {
		visitor.visitJsonArray(jArray)
	}

	def T visitJsonArray(JsonArray array)

	def dispatch accept(JsonInteger jInt, MyDslVisitor<T> visitor) {
		visitor.visitJsonInteger(jInt)
	}

	def T visitJsonInteger(JsonInteger integer)

	def dispatch accept(JsonObject jObject, MyDslVisitor<T> visitor) {
		visitor.visitJsonObject(jObject)
	}

	def T visitJsonObject(JsonObject object)

	def dispatch accept(JsonString jString, MyDslVisitor<T> visitor) {
		visitor.visitJsonString(jString)
	}

	def T visitJsonString(JsonString string)

	def dispatch accept(Load load, MyDslVisitor<T> visitor) {
		visitor.visitLoad(load)
	}

	def T visitLoad(Load load)

	def dispatch accept(Save save, MyDslVisitor<T> visitor) {
		visitor.visitSave(save)
	}

	def T visitSave(Save save)

	def dispatch accept(Minus minus, MyDslVisitor<T> visitor) {
		visitor.visitMinus(minus)
	}

	def T visitMinus(Minus minus)

	def dispatch accept(Prod p, MyDslVisitor<T> visitor) {
		visitor.visitProd(p)
	}

	def T visitProd(Prod prod)

	def dispatch accept(Sum s, MyDslVisitor<T> visitor) {
		visitor.visitSum(s)
	}

	def T visitSum(Sum sum)

	def dispatch accept(Variable v, MyDslVisitor<T> visitor) {
		visitor.visitVariable(v)
	}

	def T visitVariable(Variable variable)

}
