<pizza>
	<i if={ user && pizza.uid === user.uid } class="fa fa-fw fa-trash" onclick={ parent.delete }></i><i if={ user && pizza.uid === user.uid } class="fa fa-fw fa-edit" onclick={ parent.edit }></i><a href={ pizza.imageURL } if={ pizza.imageURL }><img src={ pizza.imageURL }></a><span>{ key } --- { new Date(pizza.createdAt).toLocaleTimeString() } --- <span class="title">{ pizza.title }</span></span><span show={ pizza.updatedAt }> --- EDITED: { new Date(pizza.updatedAt).toLocaleTimeString() }</span><span show={ pizza.author }> --- BY: { pizza.author }</span>

	<script>
		console.log('PIZZA:', this);
		this.user = firebase.auth().currentUser;

	</script>

	<style>
		:scope:not(:last-child) {
			display: block;
			margin-bottom: 15px;
		}
		img {
			vertical-align: middle;
			width: 100px;
		}
		.fa-trash:hover {
			color: red;
			cursor: pointer;
		}
		.fa-edit:hover {
			color: #2196f3;
			cursor: pointer;
		}
		.title {
			color: #8bc34a;
			text
		}
	</style>
</pizza>
