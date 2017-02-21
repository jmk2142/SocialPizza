<app>
	<menu></menu>
	<p>Pizza Art</p>
	<input type="text" value="" ref="title" placeholder="Enter title of your pizza art" onkeypress={ makePizza }>
	<button onclick={ makePizza }>MAKE PIZZA</button>

	<progress value="0" max="100" ref="uploader">0%</progress>
	<input type="file" ref="fileInput" onchange={ fileUpload } value="upload">

	<div class="gallery">
		<strong>OBJECT LIST</strong><br><br>
		<pizza each={ pizza, key in pizzas }></pizza>
	</div>

	<!-- EDITOR -->
	<editor if={ editing } data={ editing }></editor>


	<button onclick={ recordVideo }>Record Video</button>
	<button onclick={ stopVideo }>STOP</button>
	<a href={ blobURL }>blobURL</a>
	<video ref="localVideo" autoplay muted></video>


	<script>
		var that = this;
		console.log('app.tag');

		this.fileUpload = function(event){
			// Get file
			var file = event.target.files[0];

			// Create storage ref
			var storageRef = firebase.storage().ref('photos/pizzas/' + file.name);

			// Upload file
			var task = storageRef.put(file);

			// Update progress bar
			task.on('state_changed', function(snapshot){
				  var percentage = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;

					console.log(percentage);
					that.refs.uploader.value = percentage;
					console.log('snapshot:', snapshot);
				}, function error(err) {
					console.log(err);
				}, function complete(x) {
					console.log('complete:', x);
					that.refs.uploader.value = 0;
					that.downloadURL = task.snapshot.downloadURL;

					// https://firebase.google.com/docs/reference/js/firebase.storage.UploadTask
					console.log('task: ', task);
					// https://firebase.google.com/docs/reference/js/firebase.storage.UploadTaskSnapshot
					console.log('task.snapshot: ', task.snapshot);
					console.log('task.snapshot.ref: ', task.snapshot.ref);
					window.taskSnapRef = task.snapshot.ref;
					that.fileReference = task.snapshot.ref;
			});

			window.storageRef = storageRef;
			console.log('storageRef:', storageRef);
			console.log('task:', task);
		};

		this.pizzas = null;

		var pizzaRef = database.ref('pizza');

		var earliest = '';

		// The job of update might end up the job of the ref.
		pizzaRef.orderByChild('createdAt').endAt(earliest).limitToLast(7).on('value', function(snapshot){
			this.pizzas = snapshot.val();

			// TEST CONVERT to ARRAY STRUCTURE using lodash
			// this.pizzaList = _.map(this.pizzas, function(pizza, key, list) {
			// 	return _.extend(pizza, {key: key});
			// });
			// console.log(this.pizzaList);
			// BETTER for sorting?

			this.update();
		}.bind(this));

		/*
			Kind of dawned on me...
			Maybe not bad practice for these NoSQL data architectures to use readable unique ids sometimes?
			E.g. /dinosaurs/...
				tyrannosaurus
				brontosaurus
				apatasaurus
			All of these in this concept are UNIQUE items in the collection.

			Man, the redundancy concept is hard to really mentally embrace.
		*/

		/*
			Need to know easy way to write to multiple references at once. Think there is a way.

			Ah... with update();
			e.g. database/user/posts/...
			e.g. database/posts/...
			var data = {x:1, y:0};
			var updates = {
				"user/posts": data, // Slashes in prop name, crazy!
				"posts": data
			};
			firebase.database().ref().update(updates);
		*/


		makePizza(event) {
			event.preventUpdate = true;

			if (event.type === "keypress" && event.which !== 13) {
				return false;
			}

			if (firebase.auth().currentUser) {
				var saved =	pizzaRef.push({
					author: firebase.auth().currentUser.displayName,
					uid: firebase.auth().currentUser.uid,
					title: this.refs.title.value,
					createdAt: firebase.database.ServerValue.TIMESTAMP,
					imageURL: this.downloadURL ? this.downloadURL : null,
					fileFullPath: that.fileReference ? that.fileReference.fullPath : null
				}).then(function(response){
					console.log(response);
					that.downloadURL = null;
				});

				this.resetForm(event);
			} else {
				alert('LOGIN to WRITE');
			}
		}

		resetForm(event) {
			this.refs.title.value = "";
			event && event.target.blur();
			this.refs.title.focus();
		}

		delete(event) {
			console.log(event.item);

			if (event.item.pizza.fileFullPath) {
				firebase.storage().ref(event.item.pizza.fileFullPath).delete();
			}

			pizzaRef.child(event.item.key).remove().catch(function(error){
				if (!firebase.auth().currentUser) {
					alert('Need to LOGIN');
					return false;
				}
			});
		}

		edit(event) {
			this.editing = event.item;
			console.log(this);
			this.update();
		}

		var that = this;
		this.blobURL = "";

		recordVideo(event) {
			var mediaConstraints = {
				audio: true,
				video: true
			};
			navigator.getUserMedia(mediaConstraints, onMediaSuccess, onMediaError);

			function onMediaSuccess(stream) {
				that.mediaRecorder = new MediaStreamRecorder(stream);
				that.mediaRecorder.mimeType = 'video/webm';
				that.mediaRecorder.ondataavailable = function(blob) {
					var blobURL = URL.createObjectURL(blob);
					that.blobURL = blobURL;
					that.update();
				}
				if (window.URL) {
					that.refs.localVideo.src = window.URL.createObjectURL(stream);
				} else {
					that.refs.localVideo.src = stream;
				}

				that.mediaRecorder.start();
			}

			function onMediaError(error) {
				console.error('media error', e);
			}
		}


		function successCallback(stream) {
			window.stream = stream;
			if (window.URL) {
				video.src = window.URL.createObjectURL(stream);
			} else {
				video.src = stream;
			}
		}


		stopVideo(event) {
			that.mediaRecorder.stop();
		}


	</script>

	<style>
		:scope {
			display: block;
			padding-top: 30px;
		}
		.gallery {
			font-family: monospace;
			margin-top: 10px;
			border: 1px solid #DDD;
			border-radius: 4px;
			padding: 4px;
		}
	</style>
</app>
