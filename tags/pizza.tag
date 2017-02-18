<pizza>
	<i class="fa fa-fw fa-trash" onclick={ parent.delete }></i>
	<i class="fa fa-fw fa-edit" onclick={ parent.edit }></i>
	<span>{ key } --- { new Date(pizza.createdAt).toLocaleTimeString() } --- { pizza.title }</span><span show={ pizza.updatedAt }> --- EDITED: { new Date(pizza.updatedAt).toLocaleTimeString() }</span>

	<script>
		// var x = 1;
	</script>

	<style>
		:scope:not(:last-child) {
			display: block;
			margin-bottom: 15px;
		}
		.fa-trash:hover {
			color: red;
			cursor: pointer;
		}
		.fa-edit:hover {
			color: #2196f3;
			cursor: pointer;
		}
	</style>
</pizza>
