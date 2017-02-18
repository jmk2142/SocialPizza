<app>
	<p>Pizza Art</p>
	<input type="text" value="" ref="title" placeholder="Enter title of your pizza art" onkeypress={ makePizza }>
	<button onclick={ makePizza }>MAKE PIZZA</button>

	<div class="gallery">
		<pizza each={ pizza, key in pizzas }></pizza>
	</div>

	<editor if={ editing } data={ editing }></editor>


	<script>
		console.log('app.tag');

		this.pizzas = null;

		var pizzaRef = database.ref('pizza');

		// The job of update might end up the job of the ref.
		pizzaRef.orderByChild('createdAt').limitToLast(10).on('value', function(snapshot){
			this.pizzas = snapshot.val();
			this.update();
		}.bind(this));


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
			pizzaRef.child(event.item.key).remove();
		}

		edit(event) {
			this.editing = event.item;
			console.log(this);
			this.update();
		}

	</script>

	<style>
		:scope {
			display: block;
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
