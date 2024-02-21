import java.util.*;

public class FA {

	private final String template;
	private final String text;
	private final int m;
	private final Set<String> alphabet = new HashSet<>();

	//<Stan, Input>, stan do ktorego mozemy pojsc
	private final Map<Pair<Integer, String>, Integer> sigma = new HashMap<>();

	public FA(final String template, final String text) {
		this.template = template;
		this.text = text;
		this.m = template.length();
		//nie chcemy powtorzen w alfabecie
		this.alphabet.addAll(Arrays.asList(template.split("")));
		computeTransitionFunction();
		finiteAutomationMatcher();
	}

	private void computeTransitionFunction() {
		//rozpatrujemy wszystkie stany q i symbole a (z alfabetu)
		for (int q = 0; q < m + 1; q++) {
			for (final String a : alphabet) {
				int k = Math.min(m + 1, q + 2);
				do {
					k -= 1;
				} while (!(template.substring(0, q) + a).endsWith(template.substring(0, k)));
				//przypisujemy najwieksza wartosc k taka, ze P_k zawiera sie w P_q(a)
				sigma.put(new Pair<>(q, a), k);
			}
		}
	}


	private void finiteAutomationMatcher() { // złożoność O(n)
		final String[] T = text.split("");
		final int n = text.length();
		int q = 0;
		for (int i = 0; i < n; i++) {
			try {
				q = sigma.get(new Pair<>(q, T[i]));
				if (q == m) {
					final int s = i - m;
					System.out.println("Wzorzec występuje z przesunięciem " + (s + 1));
				}
			} catch (final NullPointerException ex) {
				q = 0;
			}
		}
	}
}