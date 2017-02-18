<menu>
	<!-- Basically an Auth test -->
	<strong>menu.tag</strong>

	<img src={ user ? user.photoURL : "https://placehold.it/50x50" }>

	<button hide={ this.user } onclick={ signIn }>SignIN</button>
	<button show={ this.user } onclick={ signOut }>SignOUT</button>

	<script>
		console.log('menu.tag');

		this.user = firebase.auth().currentUser;

		this.signIn = function(event){
			// Start a sign in process for an unauthenticated user.
			var provider = new firebase.auth.GoogleAuthProvider();
			// provider.addScope('profile');
			// provider.addScope('https://www.googleapis.com/auth/plus.login');

			firebase.auth().signInWithRedirect(provider).then(function(result){
				  // This gives you a Google Access Token. You can use it to access the Google API.
				  var token = result.credential.accessToken;
				  // The signed-in user info.
				  this.user = result.user;
					console.log(this.user);

			}.bind(this)).catch(function(error){
				  var errorCode = error.code;
				  var errorMessage = error.message;
				  // The email of the user's account used.
				  var email = error.email;
				  // The firebase.auth.AuthCredential type that was used.
				  var credential = error.credential;
			}.bind(this));
		};

		this.signOut = function(event){
		  firebase.auth().signOut().then(function(result){
		    // success
				console.log(result);
		  }).catch(function(error){
		    // error
				console.log(error);
		  });
		};

		// Could use major cleanup.
		firebase.auth().onAuthStateChanged(function(user){
		  if (user) {
				console.log('signed in');
				this.user = user;
				console.log(this.user);
			} else {
				console.log('logged out');
				this.user = null;
			}
			console.log('this.user:', this.user);
			this.update();
		}.bind(this));
	</script>

	<style>
		:scope {
			display: block;
			background-color: #F5F5F5;
			padding: 0;
			position: fixed;
			top: 0;
			left: 0;
			right: 0;
			margin: 0;
			padding: 10px;
			text-align: right;
		}
		img {
			height: 25px;
			width: 25px;
		}
	</style>
</menu>
