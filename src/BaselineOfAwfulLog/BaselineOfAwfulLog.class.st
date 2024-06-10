Class {
	#name : #BaselineOfAwfulLog,
	#superclass : #BaselineOf,
	#category : #BaselineOfAwfulLog
}

{ #category : #loading }
BaselineOfAwfulLog class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'AwfulLog' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfAwfulLog >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'AwfulLog'
		]
]
