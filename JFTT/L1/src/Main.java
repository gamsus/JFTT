import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;

public class Main {
	public static void main(final String[] args) throws IOException {
		performLogic(args);
	}

	private static void performLogic(final String[] args) throws IOException {
		if (args.length < 3) {
			System.out.println("Uruchom program z argumentami ./java <algorytm> <wzorzec> <nazwa_pliku>");
			return;
		}
		final String algorithm = args[0];
		final String template = args[1];
		final String text = Files.readString(Path.of(args[2]), Charset.availableCharsets().get("UTF-8"));

		if (algorithm.equalsIgnoreCase("FA")) {
			new FA(template, text);
		} else if (algorithm.equalsIgnoreCase("KMP")) {
			new KMP(template, text);
		} else {
			System.out.println("Nie znaleziono algorytmu! Dopuszczalne: FA, KMP");
		}
	}
}