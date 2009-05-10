import java.util.ArrayList; // needed to give us the ArrayList type
import java.util.HashMap; // needed for hash tables

public class Javamock
{
	static int myStaticNum = 777;
	
	public static void main (String[] args)
	{
		System.out.println(myStaticNum); // show a static var from inside a static method
		int num = 11;
		String line = "i rule ";
		double d = Math.random();		
		System.out.println(line + num + "\nand " + d + " solar systems");
		
		int i = 0;
		while (i <= 5) {
			System.out.println("line " + i);
			i++;
		}
		
		String[] pet_array = {"fido", "peko", "rinrin"};
		System.out.print("\n" + pet_array[0]);
		System.out.println(pet_array.length + "\n");
		
		int[] nums = {1, 2, 3, 4};
		System.out.println(nums[1] + " " + nums.length);		
		
		Dog mydog = new Dog(); // create reference of object
		mydog.size = 5;
		mydog.breed = "afghan";
		mydog.name = "mayhem";
		mydog.bark();
		mydog.play();
		mydog.show_flag(mydog.dog_flag);
		mydog.dog_flag = false;
		mydog.show_flag(mydog.dog_flag);
				
		boolean tick1 = false;
		boolean tick2 = true;
		
		if (tick1 || tick2) {
			System.out.print("\nyay\n");
		}
		else {
			System.out.print("\nnay\n");
		}
		
		Dog[] pets = new Dog[3]; // define new dog array
		pets[0] = new Dog(); // define first as dog object
		pets[1] = new Dog();
		pets[0].name = "allie"; // assign value
		pets[1].name = "poo poo";
		pets[0].show(); // use dog method for this object in pets array
		pets[1].show();
		
		System.out.print("\nmy dog's called : " + mydog.giveName());
		
		System.out.print("\n convert string to int : " + Integer.parseInt("3") + "\n");		
		
		//String guess = helper.getUserInput("enter value:");
		//System.out.println("you entered:" + guess);
		
		String[] nameArray = {"fred", "wilma"};
		for (String name : nameArray) {
			System.out.println("array items via enhanced for loop :" + name);
		}
		
		ArrayList<String> mylist = new ArrayList<String>();
		String a = "hello"; 
		mylist.add(a);
		String b = "world"; 
		mylist.add(b);
		//for (ArrayList<String> val : mylist) {
		//	System.out.println(val);
		//}
		//System.out.println("array.. name:" + nameArray.contains("fred"));
		
		SuperDog spet = new SuperDog();
		spet.size = 5;
		System.out.println("size from inherited superdog :" + spet.giveSize());
		
		spet.setSuperDog(11, "bilbo");
		System.out.println(spet.size + " " + spet.name);
		//Canine woofwoof = new Canine();
		
		int ii = 77;
		double dd = 7.11;
		System.out.println(spet.giveValue(ii) + " " + spet.giveValue(dd));
		//returns values from overloaded methods
		
		SuperDog dpet = new SuperDog();
		// fires constructor method initialising name
		System.out.println(dpet.name);
		dpet = null; // destroy object
		
		//hash tables...
		HashMap<String, String> phoneBook = new HashMap<String, String>();
		phoneBook.put("sally smart", "555-9999"); //create object & value
		System.out.println("from a hash table, sally smart tel:" + phoneBook.get("sally smart"));
		phoneBook.remove("sally smart"); //remove object & value
		
		//hash codes...
		System.out.println("hash code for object of class mydog : " + mydog.hashCode());
		
		//final class...
		finalClass fin = new finalClass();
		fin.sayHello();
		
		//wrapping a primitive
		int iw = 288;
		Integer iWrap = new Integer(iw);
		System.out.println("wrapped integer object : " + iWrap.intValue());
		
	}
}


class Dog {
	int size;
	String breed; 
	String name;
	boolean dog_flag = true;
	
	void bark() {
		System.out.print("\n woof woof, ");
		System.out.print("\nsize:" + size + " breed:" + breed + " name:" + name + "\n");
	}
	
	void play() {
		System.out.print("\n bark a the moon....");
	}
	
	void show_flag(boolean args) {
		if (args == true) {
			System.out.print("\n dog flag is true");
		}
		else {
			System.out.print("\n dog flag was not true");
		}
	} 
	
	void show() {
		System.out.print("\n" + name);
	}
	
	String giveName() {
		return name;
	}
}


class SuperDog extends Dog {
	
	public SuperDog() { // class constructor (same name as class)
		name = "something";
	}
	
	int giveSize() {
		return size;
	}
	
	void setSuperDog(int i, String s) {
		size = i;
		name = s;
	}
	
	int giveValue(int i) {
		return i;
	}
	
	double giveValue(double i) {
		// overloading the giveValue method
		return i;
	}
}


abstract class Report {
	void runReport() {
		System.out.println("run report");
	}
	void printReport() {
		System.out.println("print report");
	}
}

class BuzzwordsReport extends Report {
	void runReport() {
		super.runReport(); //run original runReport method not inherited one
		buzzwordCompliance();
		printReport();
	}
	
	void buzzwordCompliance() {
		System.out.println("buzzword compliance");
	}
}


final class finalClass {
	final void sayHello() {
		System.out.println("hello from a final method, you can't override me!");
	}
}

/*
public class insect {
	void bite() {
		//biting code
	}
}

public interface abby {
	abstract void roam();
}

public class crawler extends insect implements abby {
	void roam() {
		//your roam code
	}
}
*/
