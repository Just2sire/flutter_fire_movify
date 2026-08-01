enum MovieRating {
  g(
    code: "G",
    label: "Tous publics",
    description:
        "Toutes les tranches d'âge sont admises. Aucun élément "
        "susceptible d'offenser les enfants.",
  ),
  pg(
    code: "PG",
    label: "Accord parental souhaité",
    description:
        "Certains contenus peuvent ne pas convenir aux enfants. "
        "Guide parental conseillé.",
  ),
  pg13(
    code: "PG-13",
    label: "Accord parental fortement recommandé",
    description:
        "Certaines scènes peuvent être inappropriées pour les enfants "
        "de moins de 13 ans.",
  ),
  r(
    code: "R",
    label: "Accompagnement obligatoire",
    description:
        "Les mineurs de moins de 17 ans doivent être accompagnés d'un "
        "parent ou tuteur adulte.",
  ),
  nc17(
    code: "NC-17",
    label: "Interdit aux 17 ans et moins",
    description: "Contenu exclusivement réservé à un public adulte.",
  ),
  notRated(
    code: "NR",
    label: "Non classé",
    description: "Film non évalué ou classification indisponible.",
  );

  const MovieRating({
    required this.code,
    required this.label,
    required this.description,
  });

  final String code;
  final String label;
  final String description;

  static MovieRating fromString(String? rating) {
    if (rating == null || rating.trim().isEmpty) {
      return MovieRating.notRated;
    }
    final normalized = rating.trim().toUpperCase();
    switch (normalized) {
      case "G":
        return MovieRating.g;
      case "PG":
        return MovieRating.pg;
      case "PG-13":
      case "PG13":
        return MovieRating.pg13;
      case "R":
        return MovieRating.r;
      case "NC-17":
      case "NC17":
        return MovieRating.nc17;
      default:
        return MovieRating.notRated;
    }
  }
}
