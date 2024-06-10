Class {
	#name : #AwfulLogEventSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'target'
	],
	#category : #'AwfulLog-Logging'
}

{ #category : #'instance creation' }
AwfulLogEventSignal class >> emit: aTargetObject [
	^ (self on: aTargetObject) emit
]

{ #category : #'instance creation' }
AwfulLogEventSignal class >> log: aTargetObject [
	self deprecated: 'Should use #emit:'.
	^ self emit: aTargetObject 
]

{ #category : #'instance creation' }
AwfulLogEventSignal class >> on: aTargetObject [
	^ self new 
		target: aTargetObject 
]

{ #category : #accessing }
AwfulLogEventSignal >> name [
	^ 'AwfulLogEventSignal on ', self target class name
]

{ #category : #printing }
AwfulLogEventSignal >> printOneLineContentsOn: stream [
	self target printOneLineContentsOn: stream 
]

{ #category : #accessing }
AwfulLogEventSignal >> target [
	^ target
]

{ #category : #accessing }
AwfulLogEventSignal >> target: anObject [
	target := anObject
]
