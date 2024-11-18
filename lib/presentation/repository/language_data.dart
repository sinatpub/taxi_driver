class Lang {
  final String image;
  final String title;
  final String sublang;
  const Lang({required this.image, required this.title, required this.sublang});
}

const allLangs = [
  Lang(image: 'assets/image/country/Flag_of_the_United_Kingdom.svg',title: 'English', sublang: 'en'),
  Lang(image: 'assets/image/country/Flag_of_Cambodia.svg',title: 'ខ្មែរ',sublang: 'km'),
];