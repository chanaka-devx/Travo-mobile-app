import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color primary = Color.fromRGBO(10, 68, 90, 1);
  static const Color coral = Color(0xFFFF7D62);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20),

                      Text(
                        "TRAVO",
                        style: TextStyle(
                          color: primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 6,
                        ),
                      ),

                      const SizedBox(height: 60),

                      Container(
                        width: 180,
                        height: 180,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuCxbznZ5yfMt3HgtF6UQsFH9teeeMDqMCwM1F45pGZK5eyT819oe_t8tOgTOEwynwCuol4nHE4zCrLjw6bVrkfjn0MLJ86bOym6xhkJHwoZntQvqcGgL1SWxUPwi9ZxzAO03P8qSSvQE7qJs_RgDZxGeBQkYKLRS0-RV1SGmYHr2DZnNWrijipieVuEHjHSZN-PZepTIgr-2u9h-l6MCI2O9TnTwm64-gSH53XkXhVSC4-mgVn-y2OTsfOnqAFI5FISVioj3T8h1Mk",
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),

                      Column(
                        children: const [
                          Text(
                            "Explore the",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Beautiful ",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: coral,
                                  ),
                                ),
                                TextSpan(
                                  text: "world!",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/signin');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Get Started",
                                      style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: primary.withOpacity(0.2)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/signin');
                              },
                              child: const Text(
                                "Continue as Guest",
                                style: TextStyle(color: primary),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signin');
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Already have an account? ",
                                style: const TextStyle(color: Colors.grey),
                                children: [
                                  TextSpan(
                                    text: "Log In",
                                    style: TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
