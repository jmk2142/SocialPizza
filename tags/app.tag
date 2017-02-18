<app>
	<menu></menu>
	<p>Pizza Art</p>
	<input type="text" value="" ref="title" placeholder="Enter title of your pizza art" onkeypress={ makePizza }>
	<button onclick={ makePizza }>MAKE PIZZA</button>

	<div class="gallery">
		<strong>OBJECT LIST</strong><br><br>
		<pizza each={ pizza, key in pizzas }></pizza>
	</div>

	<div class="gallery">
		<strong>ARRAY LIST</strong><br><br>
		<pizza each={ pizza, key in pizzaList }></pizza>
	</div>
	<button onclick={ prevPage }>PREV</button>



	<!-- EDITOR -->
	<editor if={ editing } data={ editing }></editor>


	<script>
		console.log('app.tag');

		this.pizzas = null;

		var pizzaRef = database.ref('pizza');

		var earliest = '';

		// The job of update might end up the job of the ref.
		pizzaRef.orderByChild('createdAt').endAt(earliest).limitToLast(3).on('value', function(snapshot){
			this.pizzas = snapshot.val();

			// TEST CONVERT to ARRAY STRUCTURE using lodash
			this.pizzaList = _.map(this.pizzas, function(pizza, key, list) {
				return _.extend(pizza, {key: key});
			});
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

		// Using promises / thenable
		// pizzaRef.orderByChild('createdAt').endAt(earliest).limitToLast(3).once('value').then(function(snapshot){
		// 	window.snapshot = snapshot;
		// 	console.log(snapshot)
		// 	this.pizzas = snapshot.val();
		//
		// 	// TEST CONVERT to ARRAY STRUCTURE using lodash
		// 	this.pizzaList = _.map(this.pizzas, function(pizza, key, list) {
		// 		return _.extend(pizza, {key: key});
		// 	});
		// 	console.log(this.pizzaList);
		// 	// BETTER for sorting?
		//
		// 	this.update();
		//
		// }.bind(this), function(err){
		//
		// });


		makePizza(event) {
			if (event.type === "keypress" && event.which !== 13) {
				return false;
			}

			var saved =	pizzaRef.push({
				title: this.refs.title.value,
				createdAt: firebase.database.ServerValue.TIMESTAMP
			});

			this.resetForm(event);
		}

		resetForm(event) {
			this.refs.title.value = "";
			event && event.target.blur();
			this.refs.title.focus();
		}

		delete(event) {
			// pizzaRef.child(event.item.key).remove();
			pizzaRef.child(event.item.pizza.key).remove();
		}

		edit(event) {
			this.editing = event.item;
			console.log(this);
			this.update();
		}

		prevPage(event) {

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
