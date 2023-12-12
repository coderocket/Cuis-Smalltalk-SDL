'From Cuis 6.0 [latest update: #6053] on 11 December 2023 at 3:17:44 pm'!
'Description '!
!provides: 'SDL' 1 49!
!requires: 'Automata' 1 23 nil!
SystemOrganization addCategory: #SDL!


!classDefinition: #TestSDLNFA category: #SDL!
TestCase subclass: #TestSDLNFA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'TestSDLNFA class' category: #SDL!
TestSDLNFA class
	instanceVariableNames: ''!

!classDefinition: #TestSDLTrace category: #SDL!
TestCase subclass: #TestSDLTrace
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'TestSDLTrace class' category: #SDL!
TestSDLTrace class
	instanceVariableNames: ''!

!classDefinition: #SDLDFA category: #SDL!
DFA subclass: #SDLDFA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDLDFA class' category: #SDL!
SDLDFA class
	instanceVariableNames: ''!

!classDefinition: #SDLTransition category: #SDL!
Transition subclass: #SDLTransition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDLTransition class' category: #SDL!
SDLTransition class
	instanceVariableNames: ''!

!classDefinition: #SDL category: #SDL!
Object subclass: #SDL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDL class' category: #SDL!
SDL class
	instanceVariableNames: ''!

!classDefinition: #SDLDFAState category: #SDL!
Object subclass: #SDLDFAState
	instanceVariableNames: 'adj'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDLDFAState class' category: #SDL!
SDLDFAState class
	instanceVariableNames: ''!

!classDefinition: #SDLEvent category: #SDL!
Object subclass: #SDLEvent
	instanceVariableNames: 'source message target'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDLEvent class' category: #SDL!
SDLEvent class
	instanceVariableNames: ''!

!classDefinition: #SDLTrace category: #SDL!
Object subclass: #SDLTrace
	instanceVariableNames: 'events'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDLTrace class' category: #SDL!
SDLTrace class
	instanceVariableNames: ''!

!classDefinition: #SDLTraceConflict category: #SDL!
SDLTrace subclass: #SDLTraceConflict
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'SDL'!
!classDefinition: 'SDLTraceConflict class' category: #SDL!
SDLTraceConflict class
	instanceVariableNames: ''!


!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:11:19'!
testInterleave

	| e1 e2 e3 e4 a b c  dfa vm |

	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:' B' ; yourself.
	e2 := SDLEvent new source: 'A' ; message: 'm2' ; target:' B' ; yourself.

	e3 := SDLEvent new source: 'A' ; message: 'm4' ; target:' B' ; yourself.
	e4 := SDLEvent new source: 'A' ; message: 'm5' ; target:' B' ; yourself.

	a := (NFA basic: e1 alphabet: { e1 . e2 }) seq: (NFA basic:e2 alphabet: { e1 . e2 }).

	b :=(NFA basic: e3 alphabet: { e3 . e4 }) seq: (NFA basic:e4 alphabet: { e3 . e4 }).

	c := a interleave: b.

	dfa := c toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e2 . e3 . e4 }.

	vm step ; step ; step; step.

	vm reset.

	vm tape: { e1 . e3 . e2 . e4 }.

	vm step ; step ; step; step.

	vm reset.

	vm tape: { e1 . e3 . e4 . e2 }.

	vm step ; step ; step; step.

	vm reset.

	vm tape: { e3 . e1 . e2 . e4 }.

	vm step ; step ; step; step.

	vm reset.

	vm tape: { e3 . e1 . e4 . e2 }.

	vm step ; step ; step; step.

	self assert: true.! !

!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:04:22'!
testKeep

	| e1 e2 e3 e4 a b c dfa vm alphabet |

	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:'B' ; yourself.
	e2 := SDLEvent new source: 'B' ; message: 'm2' ; target:'C' ; yourself.
	e3 := SDLEvent new source: 'C' ; message: 'm3' ; target:'A' ; yourself.
	e4 := SDLEvent new source: 'C' ; message: 'm4' ; target:'B' ; yourself.

	alphabet := { e1 . e2 . e3 . e4 }.
	
	a := (NFA basic: e1 alphabet: alphabet) seq: (NFA basic:e2 alphabet: alphabet).

	b := a seq: (NFA basic:e3 alphabet: alphabet) :: seq: (NFA basic:e4 alphabet: alphabet).

	c := b keep: 'A'.
	
	dfa := c toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e3  }.

	vm step ; step .

	vm reset.

	[
		vm reset.
	
		vm tape: { e1 . e2 . e3 }.

		vm step ; step ; step.
	
	] on: InvalidTransitionError do:[:err | self assert: true ].

	[
		vm reset.
	
		vm tape: { e1 . e2 . e3 . e4 }.

		vm step ; step ; step ; step.
	
	] on: InvalidTransitionError do:[:err | self assert: true ].

	self assert: true.! !

!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:04:34'!
testLoop

	| e1 e2 a b c dfa vm |

	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:' B' ; yourself.
	e2 := SDLEvent new source: 'A' ; message: 'm2' ; target:' B' ; yourself.

	a := NFA basic: e1 alphabet: { e1 . e2 }.

	b :=NFA basic: e2 alphabet: { e1 . e2  }.

	c := (a seq: b) loop.

	dfa := c toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e2  }.

	vm step.

	vm step.

	vm reset.

	vm tape: { e1 . e2 . e1 . e2 }.

	vm step; step; step ; step.

	self assert: true.! !

!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:11:31'!
testParallel

	| e1 e2 e3 a b c dfa vm |

	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:' B' ; yourself.
	e2 := SDLEvent new source: 'A' ; message: 'm2' ; target:' B' ; yourself.

	e3 := SDLEvent new source: 'A' ; message: 'm4' ; target:' B' ; yourself.

	a := (NFA basic: e1 alphabet: { e1 . e2 }) seq: (NFA basic:e2 alphabet: { e1 . e2 }).

	b :=(NFA basic: e3 alphabet: { e3 . e2 }) seq: (NFA basic:e2 alphabet: { e3 . e2 }).

	c := a parallel: b.

	dfa := c toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e3 . e2 }.

	vm step ; step ; step.

	vm reset.

	vm tape: { e3 . e1 . e2 }.

	vm step ; step ; step.

	[
		vm reset.
	
		vm tape: { e1 . e2 . e3 }.

		vm step ; step ; step.
	
	] on: InvalidTransitionError do:[:err | self assert: true ].

	[
		vm reset.
	
		vm tape: { e2 . e1 . e3 }.

		vm step ; step ; step.
	
	] on: InvalidTransitionError do:[:err | self assert: true ].

	self assert: true.! !

!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:06:55'!
testStrict

	| e1 e2 a b c dfa vm |


	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:' B' ; yourself.
	e2 := SDLEvent new source: 'A' ; message: 'm2' ; target:' B' ; yourself.

	a := NFA basic: e1 alphabet: { e1 . e2 }.

	b :=NFA basic: e2 alphabet: { e1 . e2  }.

	c := a seq: b.

	dfa := c toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e2  }.

	vm step.

	vm step.

	self assert: true.! !

!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:07:05'!
testUnion

	| e1 e2 a b union dfa vm |


	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:' B' ; yourself.
	e2 := SDLEvent new source: 'A' ; message: 'm2' ; target:' B' ; yourself.

	a := NFA basic: e1 alphabet: { e1 . e2 }.

	b := NFA basic: e2 alphabet: { e1 . e2  }.

	union := a union: b.

	dfa := union toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e2  }.

	vm step.

	vm reset.

	vm tape: { e2 . e1  }.

	self assert: true.! !

!TestSDLNFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 13:50:05'!
testWeak

" lifeline A, B, C, D

at A

alt 
{
	send m1 to B { }
	
	send m2 to C { }
	
}

at D 

send m3 to C { }
"

	| e1 e2 e3 parts a b dfa vm |


	e1 := SDLEvent new source: 'A' ; message: 'm1' ; target:'B' ; yourself.
	e2 := SDLEvent new source: 'A' ; message: 'm2' ; target:'C' ; yourself.
	e3 := SDLEvent new source: 'D' ; message: 'm3' ; target:'C' ; yourself.

	parts := { e1 . e2 . e3 } collect:[:each | NFA basic: each alphabet: { each } asSet ].
	
	a := ((parts at:1) union: (parts at:2)) seq: (parts at:3).
	
	b := a weak: { 'A' . 'B' . 'C'. 'D' }.
	
	dfa := b toDFA: DFA. 

	vm := DFAVM new.

	vm automaton: dfa.

	vm reset.

	vm tape: { e1 . e3  }.

	vm step.

	vm step.

	self assert: true.
	
	vm reset.

	vm tape: { e3 . e1  }.

	vm step.

	vm step.

	self assert: true.	
	
	vm tape: { e2 . e3  }.

	vm reset.

	vm step.

	vm step.

	self assert: true.		
	
	[
		vm reset.
	
		vm tape: { e3 . e2  }.

		vm step ; step.
		
		self assert: false.
	
	] on: InvalidTransitionError do:[:err | self assert: true ].
	! !

!TestSDLTrace methodsFor: 'as yet unclassified' stamp: 'DF 11/23/2023 21:31:28'!
testInterleave

	| t1 t2 t3 t4 e1 e2 e3 e4 |
	
	e1 := SDLEvent new source:'a' ; message: 'm1' ; target:'b' ; yourself.
	e2 := SDLEvent new source:'a' ; message: 'm2' ; target:'b' ; yourself.
	e3 := SDLEvent new source:'a' ; message: 'm3' ; target:'b' ; yourself. 
	e4 := SDLEvent new source:'a' ; message: 'm4' ; target:'b' ; yourself.
	
	t1 := SDLTrace new events: {e1} ; yourself.
	
	t2 := SDLTrace new events: {e2} ; yourself.	

	self assert: ( t1 interleave: t2 ) equals: { 
		SDLTrace new events: { e1 . e2 } ; yourself.
		SDLTrace new events: { e2 . e1 } ; yourself } asSet.

	t3 := SDLTrace new events: {e1 . e2} ; yourself.

	t4 := SDLTrace new events: {e3 . e4} ; yourself.	

	self assert: ( t1 interleave: t4 ) equals: { 
		SDLTrace new events: { e1 . e3 . e4 } ; yourself.
		SDLTrace new events: { e3 . e1 . e4  } ; yourself.
		SDLTrace new events: { e3 . e4 . e1  } ; yourself } asSet.
	
	self assert: ( t3 interleave: t4 ) equals: { 
		SDLTrace new events: { e1 . e2 . e3 . e4 } ;yourself.
		SDLTrace new events: { e1 . e3 . e2 . e4 } ;yourself.
		SDLTrace new events: { e1 . e3 . e4 . e2 } ;yourself.	
		SDLTrace new events: { e3 . e1 . e2 . e4 } ;yourself.
		SDLTrace new events: { e3 . e1 . e4 . e2 } ;yourself.
		SDLTrace new events: { e3 . e4 . e1 . e2 } ;yourself } asSet.
		
	self assert: (t1 interleave: t2) = (t2 interleave: t1).
	
		! !

!TestSDLTrace methodsFor: 'as yet unclassified' stamp: 'DF 11/23/2023 22:06:25'!
testParallel

	| t1 t2 t3 e1 e2 e3 e4 e5 |
	
	e1 := SDLEvent new source:'a' ; message: '1' ; target:'b' ; yourself.
	e2 := SDLEvent new source:'a' ; message: '2' ; target:'b' ; yourself.
	e3 := SDLEvent new source:'a' ; message: '3' ; target:'b' ; yourself. 
	e4 := SDLEvent new source:'a' ; message: '4' ; target:'b' ; yourself.
	e5 := SDLEvent new source:'a' ; message: '5' ; target:'b' ; yourself.
	
	t1 := SDLTrace new events: {e1 . e2 . e3} ; yourself.
	
	t2 := SDLTrace new events: {e4 . e2 . e5} ; yourself.	

	self assert: ( t1 parallel: t2 ) equals: { 
		SDLTrace new events: { e1 . e4 . e2 . e3 . e5} ; yourself.
		SDLTrace new events: { e4 . e1 . e2 . e3 . e5} ; yourself.
		SDLTrace new events: { e1 . e4 . e2 . e5 . e3} ; yourself.
		SDLTrace new events: { e4 . e1 . e2 . e5 . e3} ; yourself.
		} asSet.
		
	self assert: (t1 parallel: t2) equals: (t2 parallel: t1).
	
	t1 := SDLTrace new events: {e1 . e2 } ; yourself.
	
	t2 := SDLTrace new events: {e4 . e5} ; yourself.	
	
	t3 := SDLTrace new events: {e2 . e5} ; yourself.	

	self assert: ((t1 parallel: t2) parallel: (Set with:t3) ) equals: ((Set with:t1) parallel: (t2 parallel: t3)).

	self assert: ((t1 parallel: t3) parallel: (Set with:t2) ) equals: ((Set with:t1) parallel: (t2 parallel: t3)).

	self assert: ((t2 parallel: t1) parallel: (Set with:t3) ) equals: ((Set with:t1) parallel: (t2 parallel: t3)).

	self assert: ((t2 parallel: t3) parallel: (Set with:t1) ) equals: ((Set with:t1) parallel: (t2 parallel: t3)).

	self assert: ((t3 parallel: t1) parallel: (Set with:t2) ) equals: ((Set with:t1) parallel: (t2 parallel: t3)).

	self assert: ((t3 parallel: t2) parallel: (Set with:t1) ) equals: ((Set with:t1) parallel: (t2 parallel: t3)).
		! !

!SDLDFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 15:14:08'!
stateBuilder
	^SDLDFAState! !

!SDLDFA methodsFor: 'as yet unclassified' stamp: 'DF 12/11/2023 13:52:17'!
transitionBuilder
	^SDLTransition! !

!SDLDFA methodsFor: 'algebra' stamp: 'DF 12/11/2023 08:59:05'!
interleave: anSDLNFA

	| todo result s |
		
	result := NFA new.

	result alphabet: alphabet , anSDLNFA alphabet.
	
	s := { start . anSDLNFA start }.
	
	result addState: s.
	
	result start: s.
	
	todo := Set new.
		
	todo add: s.

	[todo isEmpty] whileFalse:[ | nextState |

	nextState := todo anyOne.
	
	todo remove: nextState.

	result addState: nextState.

	nextState first adj do:[:eachTransition | 

		s := {eachTransition to . nextState second}.

		(result states includes: s) ifFalse:[todo add: s].

		result addTransitionFrom: nextState onSymbol: eachTransition symbol to: s ].

	nextState second adj do:[:eachTransition | 

		s := {nextState first . eachTransition to}.

		(result states includes: s) ifFalse:[todo add: s].

		result addTransitionFrom: nextState onSymbol: eachTransition symbol to: s ].
	].

	accepting do:[:each |
		anSDLNFA accepting do:[:other | | a |
			a := { each . other }.
			result states includes: a :: ifTrue:[
				result markAsAccepting: a ] ] ].
	
	^result 

! !

!SDLDFA methodsFor: 'algebra' stamp: 'DF 12/11/2023 15:10:06'!
parallel: anSDLNFA

	| todo result s dic1 dic2 common |
	
	result := NFA new.

	result alphabet: alphabet , anSDLNFA alphabet.
	
	s := { start . anSDLNFA start }.
	
	result addState: s.
	
	result start: s.
	
	todo := Set new.
		
	todo add: s.

	[todo isEmpty] whileFalse:[ | nextState |

	nextState := todo anyOne.
	
	todo remove: nextState.

	result addState: nextState.

	nextState first adj do:[:eachTransition | 

		"any transition on a symbol that is not in the other nfa's alphabet yields a
		step in the first part"
		
		anSDLNFA alphabet includes: eachTransition symbol :: ifFalse:[
		
			s := {eachTransition to . nextState second}.

			(result states includes: s) ifFalse:[todo add: s].

			result addTransitionFrom: nextState onSymbol: eachTransition symbol to: s 
		] 
	].

	nextState second adj do:[:eachTransition | 

		"any transition on a symbol that is not in the other nfa's alphabet yields a
		step in the second part"

		alphabet includes: eachTransition symbol :: ifFalse: [
		
			s := {nextState first . eachTransition to}.

			(result states includes: s) ifFalse:[todo add: s].

			result addTransitionFrom: nextState onSymbol: eachTransition symbol to: s 
		]
	].

	" find all the transitions with symbols on which both nfas have a transition 
	
	"
	
	dic1 := Dictionary new.
	
	nextState first adj do:[:each | dic1 at: each symbol put: each ].

	dic2 := Dictionary new.
	
	nextState second adj do:[:each | dic2 at: each symbol put: each ].
	
	common := alphabet intersection: anSDLNFA alphabet.
	
	common do:[:each |  
		
		dic1 at:each ifPresent:[:t1 |
			dic2 at:each ifPresent:[:t2 |
				
				s := {t1 to . t2 to}.

				(result states includes: s) ifFalse:[todo add: s].

				result addTransitionFrom: nextState onSymbol: each to: s  ] ] ].		
	].

	accepting do:[:each |
		anSDLNFA accepting do:[:other | | a |
			a :=  { each. other } .
			result states includes: a :: ifTrue:[
				result markAsAccepting: a ] ] ].
	
	^result

! !

!SDLTransition methodsFor: 'as yet unclassified' stamp: 'DF 11/28/2023 22:09:39'!
from: anSDLState

	super from: anSDLState.
	
	anSDLState addTransition: self.
	
		! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 19:21:17'!
alt
	^`'alt', String newLineString`! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 19:21:44'!
else
	^`'else', String newLineString`! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 19:21:32'!
end
	^`'end', String newLineString`! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 21:19:30'!
loop
	^`'loop', String newLineString`! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 21:19:11'!
par
	^`'par', String newLineString`! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 21:19:06'!
seq
	^`'seq', String newLineString`! !

!SDL class methodsFor: 'as yet unclassified' stamp: 'DF 11/22/2023 21:19:21'!
thread
	^`'thread', String newLineString`! !

!SDLDFAState methodsFor: 'as yet unclassified' stamp: 'DF 11/28/2023 22:08:13'!
addTransition: aTransition
	adj add: aTransition! !

!SDLDFAState methodsFor: 'as yet unclassified' stamp: 'DF 11/28/2023 22:08:17'!
adj
	^adj! !

!SDLDFAState methodsFor: 'as yet unclassified' stamp: 'DF 11/28/2023 22:10:44'!
initialize
	adj := OrderedCollection new.! !

!SDLDFAState methodsFor: 'as yet unclassified' stamp: 'DF 11/28/2023 15:06:44'!
printOn: aWriteStream

	aWriteStream nextPutAll: self identityHash asString.
	
	! !

!SDLEvent methodsFor: 'accessing' stamp: 'DF 11/18/2023 15:20:29'!
message
	^message! !

!SDLEvent methodsFor: 'accessing' stamp: 'DF 11/18/2023 14:16:07'!
message: aString
	message := aString! !

!SDLEvent methodsFor: 'accessing' stamp: 'DF 11/18/2023 15:20:21'!
source
	^source! !

!SDLEvent methodsFor: 'accessing' stamp: 'DF 11/18/2023 14:15:52'!
source: aString
	source := aString! !

!SDLEvent methodsFor: 'accessing' stamp: 'DF 11/18/2023 15:20:25'!
target
	^target! !

!SDLEvent methodsFor: 'accessing' stamp: 'DF 11/18/2023 14:16:00'!
target: aString
	target := aString! !

!SDLEvent methodsFor: 'printing' stamp: 'DF 11/18/2023 14:20:41'!
printOn: aStream

	aStream nextPutAll: source.
	
	aStream nextPut:$..
	
	aStream nextPutAll: message.
	
	aStream nextPut: $..
	
	aStream nextPutAll: target.! !

!SDLEvent methodsFor: 'printing' stamp: 'DF 11/22/2023 19:50:39'!
seqDiagCall

	| aWriteStream nl |
	
	aWriteStream := WriteStream on: ''.
	
	nl := String newLineString.
		
	aWriteStream nextPutAll: source ; nextPutAll: SDLEvent arrow ; nextPutAll: target ; nextPutAll: ' : ' ; nextPutAll: message; nextPutAll: nl.

	^ aWriteStream contents.	
! !

!SDLEvent methodsFor: 'printing' stamp: 'DF 11/22/2023 19:48:30'!
seqDiagReply

	| aWriteStream |
	
	aWriteStream := WriteStream on: ''.
	
	aWriteStream nextPutAll: source; nextPutAll: SDLEvent rtlarrow ; nextPutAll: target ; nextPutAll: ':' ; nextPutAll: String newLineString.

	^ aWriteStream contents.	
! !

!SDLEvent methodsFor: 'comparing' stamp: 'DF 11/18/2023 15:16:06'!
= anObject

	self == anObject ifTrue: [ ^ true ].

	self class == anObject class ifFalse: [ ^false ].

	^source = anObject source and: [ message = anObject message ] and: [ target = anObject target ]
	! !

!SDLEvent methodsFor: 'comparing' stamp: 'DF 11/18/2023 15:16:48'!
hash

	^ (source hash bitXor: message hash) bitXor: target hash! !

!SDLEvent class methodsFor: 'as yet unclassified' stamp: 'DF 11/21/2023 20:21:01'!
arrow
	^ ' -> '! !

!SDLEvent class methodsFor: 'as yet unclassified' stamp: 'DF 11/21/2023 20:21:06'!
colon
	^' : '! !

!SDLEvent class methodsFor: 'as yet unclassified' stamp: 'DF 11/21/2023 20:57:19'!
rtlarrow
	^ ' <-- '! !

!SDLTrace methodsFor: 'initialization' stamp: 'DF 11/18/2023 14:59:28'!
initialize

	events := OrderedCollection new! !

!SDLTrace methodsFor: 'printing' stamp: 'DF 11/18/2023 15:19:27'!
printOn: aStream

	aStream nextPut:$<.
	
	events do:[:each |		each printOn: aStream ] separatedBy: [ aStream nextPut: $, ].
	
	aStream nextPut:$>.! !

!SDLTrace methodsFor: 'accessing' stamp: 'DF 11/18/2023 15:21:39'!
alphabet
	^ events asSet
	! !

!SDLTrace methodsFor: 'accessing' stamp: 'DF 11/23/2023 20:01:34'!
at: index
	^events at:index! !

!SDLTrace methodsFor: 'accessing' stamp: 'DF 11/18/2023 15:02:02'!
events
	^events! !

!SDLTrace methodsFor: 'accessing' stamp: 'DF 11/18/2023 15:01:27'!
events: anOrderedCollection
	events := anOrderedCollection ! !

!SDLTrace methodsFor: 'accessing' stamp: 'DF 11/23/2023 19:59:17'!
length
	^events size ! !

!SDLTrace methodsFor: 'testing' stamp: 'DF 11/23/2023 19:52:02'!
isConflict
	^false! !

!SDLTrace methodsFor: 'testing' stamp: 'DF 11/23/2023 19:56:41'!
isEmpty
	^events isEmpty! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 19:52:30'!
concat: aTrace

	| trace |

	aTrace isConflict ifTrue:[^aTrace].
		
	trace := SDLTrace new.
	
	trace events addAll: events.
	
	trace events addAll: aTrace events.
	
	^trace
	! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/18/2023 20:33:05'!
filter: aString

	^SDLTrace new events: (events select:[:anEvent | anEvent source = aString or:[anEvent target = aString] ]) ; yourself! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 20:17:03'!
interleave: aTrace

	aTrace isConflict ifTrue:[^aTrace].
	
	^ self interleave: aTrace at:1 at:1! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 21:23:40'!
interleave: aTrace at:i at:j

	| t r s |

	self assert: aTrace isConflict not.
	
	i = (self length + 1)  ifTrue:[^ Set with: (aTrace tailFrom: j) ].
	
	j = (aTrace length + 1)  ifTrue:[^ Set with: (self tailFrom: i) ].

 	t := self interleave: aTrace at:i at:j+1.
		
	r := t collect:[:each | each addFirst: (aTrace at:j)  ].

	s := self interleave: aTrace at:i+1 at:j.
		
	r addAll:  (s collect:[:each | each addFirst:(self at:i) ] ).
			
	^r.
! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 22:04:25'!
parallel: aTrace

	aTrace isConflict ifTrue:[^aTrace].
	
	^ (self parallel: aTrace at:1 at:1 alpha1: self alphabet alpha2: aTrace alphabet) reject:[:each | each isConflict ]! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 21:50:03'!
parallel: aTrace at:i at:j alpha1: a1 alpha2:a2

	| t s r |
	
	self assert: aTrace isConflict not.

	i = (self length + 1)  ifTrue:[^ Set with: (aTrace tailFrom: j) ].
	
	j = (aTrace length + 1)  ifTrue:[^ Set with: (self tailFrom: i) ].
	
	(self at:i) = (aTrace at:j) ifTrue:[
		
		| traces |
		
		traces := self parallel: aTrace at:i + 1 at:j + 1 alpha1:a1 alpha2:a2.
		 
		^traces collect:[:each |  each addFirst: (self at:i) ] ].
	
	((a1 includes: (aTrace at:j)) and:[ a2 includes:(self at:i) ] ) ifTrue:[
		^Set with: SDLTraceConflict new ].
	
	(a2 includes: (self at:i)) ifTrue:[
		
		| traces |
		
		traces := self parallel: aTrace at: i at: j+1 alpha1:a1 alpha2: a2.
		
		^traces collect:[:each | each addFirst: (aTrace at:j)  ] ].
		
	(a1 includes: (aTrace at:j)) ifTrue:[
		
		| traces |
		
		traces := self parallel: aTrace at: i+1 at: j alpha1:a1 alpha2: a2.
		
		^traces collect:[:each | each addFirst: (self at:i)  ] ].
	
	t := self parallel: aTrace at:i+1 at:j alpha1:a1 alpha2: a2.
		
	r := t collect:[:each | each addFirst: (self at:i) ].
	
	s := self parallel: aTrace at:i at: j+1 alpha1:a1 alpha2: a2.
		
	r addAll:  (s collect:[:each |  each addFirst: (aTrace at:j) ] ).
			
	^r.

		! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/22/2023 17:07:16'!
reverse
	^ SDLTrace new events: events reverse ; yourself! !

!SDLTrace methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 08:40:09'!
weak: names

	| ts |
	
	ts := names collect:[:each | 	Set with: (self filter: each) ].
	
	^ ts inject:(Set with: self class new) into:[:acc :each | acc parallel: each ]! !

!SDLTrace methodsFor: 'building traces' stamp: 'DF 11/23/2023 19:49:07'!
addFirst: anSDLEvent

	^ SDLTrace new events: { anSDLEvent } , events ; yourself! !

!SDLTrace methodsFor: 'building traces' stamp: 'DF 11/23/2023 21:21:01'!
tailFrom: anIndex

	^SDLTrace new events: (events copyFrom: anIndex to: events size) ; yourself! !

!SDLTrace methodsFor: 'comparing' stamp: 'DF 11/23/2023 20:36:17'!
= aTrace

	self == aTrace ifTrue: [ ^ true ].

	self class == aTrace class ifFalse: [ ^false ].

	^events = aTrace events
	
	! !

!SDLTrace methodsFor: 'comparing' stamp: 'DF 11/23/2023 21:37:41'!
hash
	^events hash! !

!SDLTrace class methodsFor: 'instance creation' stamp: 'DF 11/21/2023 20:22:35'!
event: anSDLEvent

	| trace |
	
	trace := self new.
	
	trace events add: anSDLEvent.
	
	^trace! !

!SDLTrace class methodsFor: 'instance creation' stamp: 'DF 11/18/2023 20:47:17'!
source: aString1 message: aString2 target: aString3

	| trace |
	
	trace := self new.
	
	trace events add: (SDLEvent new source: aString1 ; message: aString2 ; target: aString3 ; yourself).
	
	^trace! !

!SDLTraceConflict methodsFor: 'building traces' stamp: 'DF 11/23/2023 19:50:01'!
addFirst: anSDLEvent
	^self! !

!SDLTraceConflict methodsFor: 'testing' stamp: 'DF 11/23/2023 19:52:13'!
isConflict
	^true! !

!SDLTraceConflict methodsFor: 'testing' stamp: 'DF 11/23/2023 19:56:56'!
isEmpty
	^true! !

!SDLTraceConflict methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 19:52:48'!
concat: aTrace
	^self! !

!SDLTraceConflict methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 19:53:02'!
filter: aString
	^self ! !

!SDLTraceConflict methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 19:53:35'!
interleave: aTrace
	^self! !

!SDLTraceConflict methodsFor: 'trace algebra' stamp: 'DF 11/23/2023 19:53:53'!
reverse
	^self! !

!SDLTraceConflict methodsFor: 'printing' stamp: 'DF 11/23/2023 21:40:16'!
printOn: aStream

	aStream nextPutAll:'CONFLICT'.! !

!SequenceableCollection methodsFor: '*SDL' stamp: 'DF 11/22/2023 21:44:20'!
strict
	
	"Concatenate my traces into a single trace: <{t1,t2},{t3,t4}> = {t1^t3,t1^t4,t2^t3,t2^t4}"
	
	^self inject: (Set with: SDLTrace new) into:[:acc :each | acc concat: each ]! !

!SequenceableCollection methodsFor: '*SDL' stamp: 'DF 11/24/2023 15:41:01'!
weak: names

	^self strict weak: names! !

!Set methodsFor: '*SDL' stamp: 'DF 11/19/2023 16:55:56'!
concat: aSet 

	"concatenate every trace in self with every trace in aSet"
	
	| traces |
	
	traces := Set new.
	
	self do:[:each |
		aSet do:[:other |
			traces add: (each concat: other) ] ].

	^traces! !

!Set methodsFor: '*SDL' stamp: 'DF 11/19/2023 22:59:41'!
interleave: aSet

	"interleave every trace in self with every trace in aSet"
	
	| traces |
	
	traces := Set new.
	
	self do:[:each |
		aSet do:[:other |
			traces addAll: (each interleave: other) ] ].

	^traces! !

!Set methodsFor: '*SDL' stamp: 'DF 11/23/2023 19:45:23'!
parallel: aSet 

	"combine in parallel every trace in self with every trace in aSet"
	
	| traces |

	traces := Set new.
	
	self do:[:each |
		aSet do:[:other | 
			traces addAll: (each parallel: other) ] ].

	^traces! !

!Set methodsFor: '*SDL' stamp: 'DF 11/22/2023 17:05:30'!
reverse

	^ self collect:[:each | each reverse ]! !

!Set methodsFor: '*SDL' stamp: 'DF 11/19/2023 16:50:31'!
union: aSet

	| union |
	
	union := self copy.
	
	union addAll: aSet.
	
	^union! !

!Set methodsFor: '*SDL' stamp: 'DF 11/23/2023 21:56:32'!
weak: names
	
	^ (self collect: [:each | each weak: names ])  flatten
! !

!NFA methodsFor: '*SDL' stamp: 'DF 12/11/2023 15:11:45'!
interleave: anNFA

	| m1 m2 |
	
	" converting to an SDLNFA creates a DFA with transitions that add themselves to 
	the adjacency lists of their source states. "
	
	m1 := self toDFA: DFA :: asAutomaton: SDLDFA.
	
	m2 := anNFA toDFA: DFA :: asAutomaton: SDLDFA.
	
	^ m1 interleave: m2! !

!NFA methodsFor: '*SDL' stamp: 'DF 11/30/2023 21:22:38'!
keep: name

	"replace with epsilon any transition on an event that is neither sent nor received by name"
	
	| anNFA |
	
	anNFA := NFA new.
	
	anNFA alphabet: (alphabet select:[:each | (name = each source) or:[ name = each target ] ]).
	
	states do:[:each | 		anNFA addState: each ].
	
	anNFA start: start.
	
	transitions do:[:each | | s |
		
		s := ​(each symbol ~= Epsilon) and: [name = each symbol source :: or: [name = each symbol target ] ] :: 
			ifTrue:[each symbol] 
			ifFalse:[Epsilon].
		
		anNFA addTransitionFrom: each from onSymbol: s to: each to ].
	
	accepting do:[:each | anNFA markAsAccepting: each ].
	
	^anNFA! !

!NFA methodsFor: '*SDL' stamp: 'DF 12/11/2023 15:10:52'!
parallel: anNFA

	| m1 m2 |
		
	" converting to an SDLDFA creates a DFA with transitions that add themselves to 
	the adjacency lists of their source states. "
	
	m1 := self toDFA: DFA :: asAutomaton: SDLDFA.
	
	m2 := anNFA toDFA: DFA :: asAutomaton: SDLDFA.
	
	^ m1 parallel: m2! !

!NFA methodsFor: '*SDL' stamp: 'DF 12/11/2023 15:13:32'!
weak: names

	| nfas |
	
	nfas := names collect:[:each | self keep: each ].
	
	^ nfas fold:[:acc :each | acc parallel: each]
	
	! !

!NFA class methodsFor: '*SDL' stamp: 'DF 12/11/2023 15:15:08'!
basic: aSymbol alphabet: aSet

	| result p q |
	
	result := NFA new.
	
	result alphabet: aSet.
	
	p := result stateBuilder new.
	
	q := result stateBuilder new.
	
	result addState: p; addState: q.
	
	result start: p.
	
	result addTransitionFrom: p onSymbol: aSymbol  to: q.
	
	result markAsAccepting: q.
	
	^result
	! !
