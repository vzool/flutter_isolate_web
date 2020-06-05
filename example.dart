/*
 * Copyright (C) 2020 DE�K JAHN G�bor.
 * All rights reserved.
 */

```dart
final worker = BackgroundWorker();
int counter = 0;

void main() {
  // Start the worker/isolate at the `entryPoint` function.
  isolates.spawn<int>(entryPoint,
    name: "counter",
    // Executed every time data is received from the spawned worker/isolate.
    onReceive: setCounter,
    // Executed once when spawned worker/isolate is ready for communication.
    onInitialized: () => isolates.send(counter, to: "counter")
  );
}

// Set new count and display current count.
void setCounter(int count) {
  counter = count;
  print("Counter is now $counter");
  
  // We will no longer be needing the worker/isolate, let's dispose of it.
  isolates.kill("counter");
}

// This function happens in the worker/isolate.
void entryPoint(Map<String, dynamic> context) {
  // Calling initialize from the entry point with the context is
  // required if communication is desired. It returns a messenger which
  // allows listening and sending information to the main worker/isolate.
  final messenger = HandledIsolate.initialize(context);

  // Triggered every time data is received from the main isolate.
  messenger.listen((count) {
    // Add one to the count and send the new value back to the main
    // isolate.
    messenger.send(++count);
  });
}
```
