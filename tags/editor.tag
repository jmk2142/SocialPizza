<editor>
	<p>EDITOR</p>
	<input type="text" ref="titleInput" value={ pizza.title } onkeypress={ save }>
	<button onclick={ save }>UPDATE</button>
	<button onclick={ cancel }>CANCEL</button>

	<script>
		console.log('editor.tag', this);

		this.key = this.opts.data.key;
		this.pizza = this.opts.data.pizza;

		save(event) {
			if (event.type === "keypress" && event.which !== 13) {
				return false;
			}
			database.ref('pizza/' + this.key).update({
				title: this.refs.titleInput.value,
				updatedAt: firebase.database.ServerValue.TIMESTAMP
			});
			this.cancel();
		}

		cancel(event) {
			this.parent.editing = null;
			this.parent.update();
		}

	</script>
	<style>
		:scope {
			display: block;
		}
	</style>
</editor>
