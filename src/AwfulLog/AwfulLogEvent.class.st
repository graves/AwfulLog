Class {
	#name : #AwfulLogEvent,
	#superclass : #Announcement,
	#instVars : [
		'id',
		'processId',
		'timestamp'
	],
	#classVars : [
		'IdCounter',
		'LogEventAnnouncer'
	],
	#category : #'AwfulLog-Logging'
}

{ #category : #accessing }
AwfulLogEvent class >> announcer [
	^ LogEventAnnouncer ifNil: [ LogEventAnnouncer := Announcer new ]
]

{ #category : #accessing }
AwfulLogEvent class >> beaconMemoryLogger [
	"Create, start and return a new MemoryLogger using a Beacon
	directly wired to the AwfulLogEvent announcer.
	Note that I can be invoked on subclasses. wtf"
	
	| beacon memoryLogger |
	beacon := Beacon new. 
	beacon announcer: self announcer.
	memoryLogger := MemoryLogger new.
	memoryLogger name: 'Awful Mtv'.
	memoryLogger beacon: beacon.
	memoryLogger startFor: self.
	^ memoryLogger
]

{ #category : #'class initialization' }
AwfulLogEvent class >> initialize [
	IdCounter := 0.
	self environment
		at: #SessionManager
		ifPresent: [ :manager | manager default registerNetworkClassNamed: self name ]
		ifAbsent: [ Smalltalk addToStartUpList: self ]
]

{ #category : #accessing }
AwfulLogEvent class >> logToBeacon [
	self stopLoggingToBeacon.
	^ self announcer 
		when: AwfulLogEvent 
		do: [ :event | (AwfulLogEventSignal on: event) emit ]
		for: self
]

{ #category : #accessing }
AwfulLogEvent class >> logToTranscript [
	self stopLoggingToTranscript.
	^ self announcer 
		when: AwfulLogEvent 
		do: [ :event | self crTrace: event ]
		for: self
]

{ #category : #accessing }
AwfulLogEvent class >> nextId [
	"This should be thread safe because SmallInteger
	arithmetic primitives cannot be interrupted"

	^ IdCounter := IdCounter + 1
]

{ #category : #convenience }
AwfulLogEvent class >> open [
	^ self announcer inspect
]

{ #category : #'system startup' }
AwfulLogEvent class >> startUp [
	"Reset the id counter"

	IdCounter := 0
]

{ #category : #convenience }
AwfulLogEvent class >> stopLoggingToTranscript [
	self announcer unsubscribe: self
]

{ #category : #'system startup' }
AwfulLogEvent class >> ustartUp [
	"Reset the id counter"

	IdCounter := 0
]

{ #category : #accessing }
AwfulLogEvent >> announcer [
	^ self class announcer
]

{ #category : #actions }
AwfulLogEvent >> emit [
	self announcer announce: self
]

{ #category : #accessing }
AwfulLogEvent >> id [
	"Return my numerical id or sequence number, unique in this image session."
	
	^ id
]

{ #category : #initialization }
AwfulLogEvent >> initialize [
	super initialize.
	timestamp := DateAndTime now.
	id := self nextId.
	processId := ZnUtils currentProcessID
]

{ #category : #accessing }
AwfulLogEvent >> nextId [
	^ self class nextId
]

{ #category : #printing }
AwfulLogEvent >> printContentsOn: stream [
	"Subclasses should implement this to add output"
]

{ #category : #printing }
AwfulLogEvent >> printHeaderOn: stream [
	"Print my generic context part, <date> <time> <seq-nr> <process> [ subclass addition], to stream"
	
	timestamp printYMDOn: stream.
	stream space.
	timestamp printHMSOn: stream.
	stream space.
	id \\ 1000 printOn: stream base: 10 length: 3 padded: true.
	stream space.
	processId printOn: stream base: 10 length: 6 padded: true
]

{ #category : #printing }
AwfulLogEvent >> printOn: stream [
	self printHeaderOn: stream.
	stream space.
	self printContentsOn: stream
]

{ #category : #accessing }
AwfulLogEvent >> processId [
	"Return a numeric process id"
	
	^ processId
]

{ #category : #initialize }
AwfulLogEvent >> processId: anObject [
	processId := anObject
]

{ #category : #accessing }
AwfulLogEvent >> stopLoggingToBeacon [.
	self announcer unsubscribe: self
]

{ #category : #accessing }
AwfulLogEvent >> timestamp [
	"Return the point in time when I was created"

	^ timestamp
]
