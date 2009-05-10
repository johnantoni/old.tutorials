import java.io.*;

public class JFile implements Serializable {
	
	static final long serialVersionUID = 1381561046643289825L;
	// generate via the commandline tool serialver [class]
	// ... run after compiling .java file
	
	private int width;
	private int height;
	
	public void setWidth(int w) {
		width = w;
	}
	
	public void setHeight(int h) {
		height = h;
	}
	
	public static void main(String[] args) {
		JFile mybox = new JFile();
		mybox.setWidth(50);
		mybox.setHeight(33);
		
		System.out.println("... Serialization demo");
		
		// save object to file
		try {
			ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream("foo.ser"));
			os.writeObject(mybox);
			//os.close;
		} 
		catch(IOException ex) {
			ex.printStackTrace();
		}

		// restore object from file
		try {
			ObjectInputStream is = new ObjectInputStream(new FileInputStream("foo.ser"));
			JFile myboxRestore = (JFile) is.readObject();
			
			System.out.println("object saved & restored from file... height : " + myboxRestore.height + " width : " + myboxRestore.width);
		}
		catch(Exception ex) {
			ex.printStackTrace();
		}
		
		System.out.println("current class uid: " + serialVersionUID);
		
		// string spliting
		String toTest = "get the answer?/green";
		String[] result = toTest.split("/");
		for (String token:result) {
			System.out.println(token);
		}
		// split() method takes the "/" and uses it to break apart the string
		// into two pieces.  the for, loops through the array and prints out 
		// the two tokens; or array elements.
		
		
	}
} 