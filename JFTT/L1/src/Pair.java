import java.util.Objects;

public class Pair<K, V> {

	private final K first;
	private final V second;

	public Pair(final K first, final V second) {
		this.first = first;
		this.second = second;
	}

	public K getFirst() {
		return this.first;
	}

	public V getSecond() {
		return this.second;
	}

	@Override
	public boolean equals(final Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		final Pair<?, ?> pair = (Pair<?, ?>) o;
		return Objects.equals(this.first, pair.first) && Objects.equals(this.second, pair.second);
	}

	@Override
	public int hashCode() {
		return Objects.hash(this.first, this.second);
	}
}
