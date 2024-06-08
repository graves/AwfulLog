# Awful Log

These classes come from [Zinc](https://github.com/svenvc/zinc), they are just stripped down to a minimal beacon logging implementation. Subclass `AwfulLogEvent` to log beacons.

See: [How to log Zinc events using Beacon](https://book.gtoolkit.com/how-to-log-zinc-events-using-beacon-94i4898osisv77xpzco65f9tq) where this was ripped from.

## Load Lepiter				After installing with `Metacello`, you will be able to execute```#BaselineOfAwfulLog asClass loadLepiter```

## How to Log `AwfulLog` events

The class side of `AwfulLogEvent`
```st
Announcement subclass: #AwfulLogEvent
	instanceVariableNames: 'id processId timestamp'
	classVariableNames: 'IdCounter LogEventAnnouncer'
	package: 'AwfulLog'
```
maintains a singleton announcer, accessed through `AwfulLogEvent>>#announcer` , that is used to announce all log events. Consumers interested in log events can register with that announcer.
```st
AwfulLogEvent announcer 
	when: AwfulLogEvent 
	do: [ :event | 
		self inform: 'Awful Log: ', event printString ].
```

## Direct logging to transcript
The simples way to log all AwfulLog events is using `AwfulLogEvent>>#logToTranscript` . That registers a consumer for logging announcements and prints them to the transcript. It does not use `Beacon`, but directly prints announcements.

## `AwfulLogEvent logToTranscript`
  
This is a global announcer. The subscription remains there until explicitly removed.

A different subclass of `AwfulLogEvent` can be used to listen only for events of a given type.

## Direct logging with `Beacon`
The first and simplest way to use Beacon with AwfulLog events is through AwfulLogEvent>>#logToBeacon . This captures all log events raised by `AwfulLog` and converts them to `Beacon` signals, by wrapping them in an instance of `AwfulLogEventSignal` .

## `AwfulLogEvent logToBeacon.`
  
We can work with any `Beacon` logger to handle these signals; for example a `MemoryLogger` to save the signals in memory, or a `NonInteractiveTranscriptLogger` logger to directly print siglans to stdout.

`MemoryLogger startFor: AwfulLogEventSignal`.
  
To filter for particular types of announcements we can use a custom condition:
```st
MemoryLogger startFor: (AwfulLogEventSignal where: [ :aSignal |
	aSignal target isKindOf: AwfulClientLogEvent]).
  
MemoryLogger stop
  
MemoryLogger reset.
  
MemoryLogger instance
```

## Using a custom `Beacon`
The second, and more complex way to handle `AwfulLog` log events using `Beacon`, is to create a new `Beacon` instance that directly listens for announcement announced by `AwfulLogEvent>>#announcer` .

In this case the log announcements from `AwfulLog` are directly used as `Beacon` signals without any conversion.
```st
beacon := Beacon new 
	announcer: AwfulLogEvent announcer
```
The logger that we use next needs to explicitly listed to the `Beacon` instance we previously created.
```st
logger := MemoryLogger new 
	beacon: beacon;
	startFor: AwfulClientLogEvent
  
logger stop.
  
logger reset
```