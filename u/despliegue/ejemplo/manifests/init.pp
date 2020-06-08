
class ejemplo(
	$tipovariante,
){
	case $tipovariante {
	   a: {
	   	include ejemplo::variantea
	   }
	   b: {
		include ejemplo::varianteb
	   }
	}
}
