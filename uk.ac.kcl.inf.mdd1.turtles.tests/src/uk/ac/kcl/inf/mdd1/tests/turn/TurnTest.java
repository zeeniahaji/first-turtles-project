package uk.ac.kcl.inf.mdd1.tests.turn;

import org.eclipse.xpect.runner.XpectRunner;
import org.eclipse.xpect.xtext.lib.tests.XtextTests;
import org.junit.runner.RunWith;

@RunWith(XpectRunner.class)
public class TurnTest extends XtextTests {
    @org.junit.Test
    public static void logTestedFile() {
        String testedFile = "uk.ac.kcl.inf.mdd1.turtles/src/uk/ac/kcl/inf/mdd1/Turtles.xtext";
        System.out.println("TESTED_FILE: " + testedFile);
    }
}
