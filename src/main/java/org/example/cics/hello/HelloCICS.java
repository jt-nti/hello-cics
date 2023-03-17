package org.example.cics.hello;

import com.ibm.cics.server.invocation.CICSProgram;

public class HelloCICS {

    @CICSProgram("HELLODFH")
    public void helloProgram() {        
        System.out.println("Hello CICS!");    
    }
}
