import 'package:flutter/material.dart';

import 'dbweather.dart';
import 'models/weather.dart';
import 'models/weatherapiclient.dart';

import 'package:sqflite/sqflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await weatherdb.initDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var user;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/profile': (context) => ProfilePage(user: user,),
      },
    );
  }
}

class HomePage extends StatefulWidget {

  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
   final TextEditingController searchController = TextEditingController();
    Weather weatherInfo=Weather();
    void searchWeather() {
    String city = searchController.text;
    // Appeler l'API pour obtenir les informations météorologiques de la ville
    // Mettre à jour la variable weatherInfo avec les données récupérées
    // Exemple : weatherInfo = await WeatherApiClient().fetchWeatherByCity(cityName);
  }

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(begin: Colors.white, end: Color.fromARGB(255, 51, 122, 245)).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ACCUEIL'),
      ),
      body:
      Stack(
          children: [
            Positioned.fill(
            child: Image.asset(
              'assets/cielBlue.webp',
              fit: BoxFit.cover,
            ),
          ),
         // Image.asset('cielBlue.webp'), // Remplacez 'path_to_image' par le chemin de votre image d'accueil
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return Text(
                      ' Weather in your city',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: _colorAnimation.value,
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.black,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      //cursorColor: Colors.black,
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by city',
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Récupérer la valeur de la barre de recherche
                      String searchValue = searchController.text;

                      // Afficher la valeur dans la console
                      print('Recherche: $searchValue');

                      // Appeler la méthode de recherche appropriée avec la valeur
                      WeatherApiClient().fetchWeatherData(searchValue).then((weatherData) {
                        // Traiter les données de la météo récupérées ici
                        setState(() {
                          weatherInfo = weatherData;
                        });
                        // Vous pouvez accéder aux informations météorologiques comme weatherData.description, weatherData.temp, etc.
                      });
                    },
                    child: Text('search'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
               Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'Description: ${weatherInfo!.description}',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Wind: ${weatherInfo!.wind} m/s',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Temperature: ${weatherInfo!.temp}°C',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Clouds: ${weatherInfo!.clouds}%',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Low',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              '${weatherInfo!.low}°C',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'High',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              '${weatherInfo!.high}°C',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Feels Like',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              '${weatherInfo!.feelsLike}°C',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ],
            ),
          ),
        ],
      ),
      
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Accueil'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                User user = User('John Doe', 'johndoe@example.com'); // Remplacez ces valeurs par celles de l'utilisateur actuel
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                );
              },
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre adresse e-mail';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Validation réussie, traitez les données du formulaire ici
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    // Ajoutez votre logique de connexion ici
                  }
                },
                child: Text('Se connecter'),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: _navigateToSignUp,
                child: Text('Créer un compte'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SignUpPage extends StatefulWidget {


  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _profileImage;

    void _pickProfileImage() async {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage.path);
        });
      }
    }

    bool _obscurePassword = true;

    @override
    void initState() {
      super.initState();
      _obscurePassword = true;
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    _pickProfileImage();
                  },
                  child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null ? Icon(Icons.camera_alt, size: 50.0) : null,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Ajouter votre photo',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),

              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom d\'utilisateur';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre adresse e-mail';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer votre mot de passe';
                }
                return null;
              },
            ),

              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Validation réussie, traitez les données du formulaire ici
                  String username = _usernameController.text ;
                  String email = _emailController.text;
                  String password = _passwordController.text ;
                  // Ajoutez votre logique d'inscription ici
                  weatherdb().createData( data: {
                    "id": DateTime.now().microsecondsSinceEpoch,
                    "username":username,
                    "email":email,
                    "password":password
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enregistré avec succès")));
                  Future.delayed(Duration(seconds: 5), (){
                    weatherdb().getLastEntry();
                  });
                 }
              },

                child: Text('S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final User user;


  ProfilePage({required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

    void _pickProfileImage() async {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _profileImage = File(pickedImage.path);
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PROFIL'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: weatherdb().getLastEntry(),
            builder: (context, snapshot) {
            if(snapshot.hasData){
              var user = snapshot.data  as Map;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    GestureDetector(
                    onTap: () {
                      _pickProfileImage();
                    },
                    child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: _profileImage == null ? Icon(Icons.camera_alt, size: 50.0) : null,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Ajouter votre photo',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
                  SizedBox(height: 16.0),
                  Text(
                    'Nom d\'utilisateur:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user['username'],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user['email'],
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              );
            }else{
              return CircularProgressIndicator();
            }
            }
          ),
        ),
      ),
    );
  }
}




class User {
  final String username;
  final String email;

  User(this.username, this.email);
}

