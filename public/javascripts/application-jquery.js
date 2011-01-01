var $j = jQuery.noConflict();

$j(document).ready(function(){

    $j("table.items tbody tr").hover(
        function(){
            $j(this).addClass("hovering");
            $j(this).find('div.controls').show();
        },
        function(){
            $j(this).removeClass("hovering");
            $j(this).find('div.controls').hide();
        }
        );

});
