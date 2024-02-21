//algorytm najlepiej uzywac, gdy tekst i szukany pattern maja duzo wspolnych znakow
public class KMP {
	private final String template;
	private final String text;
	private final int m;
	private final int n;

	//najdluzszy prefix poprzedzajacy sufix
	private final int[] lpsTable;

	public KMP(final String template, final String text) { //złożoność O(n + m)
		this.template = template;
		this.text = text;
		this.m = template.length();
		this.n = text.length();
		this.lpsTable = new int[this.m];
		computePrefixFunction();
		algorithm();
	}

	//zlozonosc obliczeniowa: O(m)
	private void computePrefixFunction() {
		final String[] T = template.split("");

		//ustawiamy pierwsza wartosc na 0
		lpsTable[0] = 0;
		int k = 0;
		//wyliczamy najdluzszy prefix, ktory jest jednoczesnie suffixem
		for (int q = 1; q < m; q++) {
			while (k > 0 && !T[k].equals(T[q])) {
				k = lpsTable[k - 1];
			}
			if (T[k].equals(T[q])) {
				k++;
			}
			lpsTable[q] = k;
		}
	}

	private void algorithm() { //Zlozonosc O(n)
		final String[] splitTemplate = template.split("");
		final String[] splitText = text.split("");
		int q = 0;
		for (int i = 0; i < n; i++) {
			while (q > 0 && !splitTemplate[q].equals(splitText[i])) { //dopoki znaki sie nie zgadzaja, cofamy sie w wzorcu za pomoca funkcji przejscia
				q = lpsTable[q - 1];
			}
			if (splitTemplate[q].equals(splitText[i])) { // jesli znaki sie zgadzaja, przesuwamy sie do kolejnego znaku w wzorcu
				q++;
			}
			if (q == m) {
				System.out.println("Wzorzec wystepuje z przesunieciem " + (i - m + 1));
				q = lpsTable[q - 1]; // przesuwamy za pomoca funkcji przejscia
			}
		}
	}
}
