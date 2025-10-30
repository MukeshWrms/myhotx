import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myhotx/ui/google_signin_screen.dart';

class DashboardScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  final GoogleSignIn googleSignIn;

  const DashboardScreen({
    super.key,
    required this.user,
    required this.googleSignIn,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Hotel> _hotels = [];
  List<Hotel> _filteredHotels = [];

  @override
  void initState() {
    super.initState();
    _initializeHotels();
    _searchController.addListener(_filterHotels);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeHotels() {
    // Sample hotel data - replace with your actual data source
    _hotels = [
      Hotel(
        name: 'Grand Plaza Hotel',
        city: 'New York',
        state: 'NY',
        country: 'USA',
        imageUrl:
            'https://images.unsplash.com/photo-1564501049412-61c2a3083791?w=400',
        rating: 4.5,
        price: '\$200',
      ),
      Hotel(
        name: 'Seaside Resort',
        city: 'Miami',
        state: 'FL',
        country: 'USA',
        imageUrl:
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
        rating: 4.2,
        price: '\$180',
      ),
      Hotel(
        name: 'Mountain View Inn',
        city: 'Denver',
        state: 'CO',
        country: 'USA',
        imageUrl:
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
        rating: 4.0,
        price: '\$150',
      ),
      Hotel(
        name: 'Tokyo Central Hotel',
        city: 'Tokyo',
        state: 'Kanto',
        country: 'Japan',
        imageUrl:
            'https://images.unsplash.com/photo-1584132967334-10e028bd69f7?w=400',
        rating: 4.7,
        price: '\$220',
      ),
      Hotel(
        name: 'Paris Luxury Suites',
        city: 'Paris',
        state: 'Île-de-France',
        country: 'France',
        imageUrl:
            'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
        rating: 4.8,
        price: '\$250',
      ),
    ];
    _filteredHotels = _hotels;
  }

  void _filterHotels() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filteredHotels = _hotels;
      });
      return;
    }

    setState(() {
      _filteredHotels = _hotels.where((hotel) {
        return hotel.name.toLowerCase().contains(query) ||
            hotel.city.toLowerCase().contains(query) ||
            hotel.state.toLowerCase().contains(query) ||
            hotel.country.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _handleLogout() async {
    try {
      // Use the same GoogleSignIn instance that was used for sign in
      await widget.googleSignIn.signOut();

      // Optional: Also disconnect to fully revoke access
      await widget.googleSignIn.disconnect();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GoogleSignInScreen()),
        (route) => false, // Remove all routes from stack
      );
    } catch (e) {
      // If there's an error with signOut, still navigate to login screen
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GoogleSignInScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // User Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.photoUrl ?? ''),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.displayName ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.user.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by hotel name, city, state, or country...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredHotels.length} hotel(s) found',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Hotels List
          Expanded(
            child: _filteredHotels.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hotel_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hotels found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      return HotelCard(hotel: hotel);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Hotel {
  final String name;
  final String city;
  final String state;
  final String country;
  final String imageUrl;
  final double rating;
  final String price;

  Hotel({
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });
}

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                hotel.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.hotel, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            // Hotel Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${hotel.city}, ${hotel.state}, ${hotel.country}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        hotel.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        hotel.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Text(
                        '/night',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
