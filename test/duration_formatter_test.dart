import "package:flutter_test/flutter_test.dart";
import "package:movify/core/extensions/int_extensions.dart";

void main() {
  group("DurationFormatter extension tests", () {
    test("returns 0min for 0 or negative values", () {
      expect(0.toFormattedDuration(), equals("0min"));
      expect((-15).toFormattedDuration(), equals("0min"));
    });

    test("formats minutes only when under 60 minutes", () {
      expect(45.toFormattedDuration(), equals("45min"));
      expect(5.toFormattedDuration(), equals("5min"));
    });

    test("formats exact hours without trailing minutes", () {
      expect(60.toFormattedDuration(), equals("1h"));
      expect(120.toFormattedDuration(), equals("2h"));
    });

    test("formats hours and minutes with leading zero padding for minutes", () {
      expect(65.toFormattedDuration(), equals("1h05min"));
      expect(142.toFormattedDuration(), equals("2h22min"));
    });
  });
}
