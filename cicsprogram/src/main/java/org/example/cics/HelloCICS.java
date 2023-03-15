package org.example.cics.hello;

public class HelloCICS {

    @CICSProgram("HELLODFH")
	public void helloCICS() {
		System.out.println("Hello CICS!");
	}
}
