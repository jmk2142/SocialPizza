<app>
	<p>Pizza Art</p>
	<input type="text" value="" ref="title" placeholder="Enter title of your pizza art" onkeypress={ makePizza }>
	<button onclick={ makePizza }>MAKE PIZZA</button>

	<ol>
		<li each={ pizza, id in pizzas }>
			{ id } --- { new Date(pizza.createdAt).toDateString() } --- { pizza.title }
			<button onclick={ parent.delete }>DELETE</button>
		</li>
	</ol>

	<script>
		console.log('app.tag');

		this.pizzas = null;

		this.pizza = {
			title: ""
		};

		var pizzaRef = database.ref('pizza');

		// The job of update might end up the job of the ref.
		pizzaRef.on('value', function(snapshot){
			console.log('snapshot', snapshot);
			this.pizzas = snapshot.val();
			console.log('this.pizzas:', this.pizzas);
			this.update();
		}.bind(this));


		makePizza(event) {
			if (event.type === "keypress" && event.which !== 13) {
				return false;
			}

			this.pizza.title = this.refs.title.value;
			this.pizza.createdAt = firebase.database.ServerValue.TIMESTAMP;

			var saved =	pizzaRef.push(this.pizza, function(x, y){
			  console.log('x:', x);
				console.log('y:', y);
			});

			this.reset(event);
		}

		reset(event) {
			this.refs.title.value = "";
			event && event.target.blur();
			this.refs.title.focus();
		}

		delete(event) {
			pizzaRef.child(event.item.id).remove();
		}
	</script>

	<style>
		:scope {
			display: block;
		}
	</style>
</app>
