// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
		$(document).ready(function(){
        $( "#begin_period" ).datepicker();
        $('#hour').timepicker({});

			//Examples of how to assign the ColorBox event to elements
			$(".inline").colorbox({inline:true, width:"60%", height:"60%"});
			$(".callbacks").colorbox({
				onOpen:function(){ alert('onOpen: colorbox is about to open'); },
				onLoad:function(){ alert('onLoad: colorbox has started to load the targeted content'); },
				onComplete:function(){ alert('onComplete: colorbox has displayed the loaded content'); },
				onCleanup:function(){ alert('onCleanup: colorbox has begun the close process'); },
				onClosed:function(){ alert('onClosed: colorbox has completely closed'); }
			});

		});
function Imprimir(){
window.print();
}
function MM_openBrWindow(theURL,winName,features) {
window.open(theURL,winName,features);
}

function PrintDiv(div)
{
	$('#'+div).printElement();
}

jQuery(document).ready(function( $ ){

 $(".sem_filtro").click(function ()
    {
      $(".txt_busca").val("");
      $(".texto1").hide();
      $(".txt_busca").hide();
      $(".label_busca").hide();
      $(".consulta").show();

    });
  $(".filtro").click(function ()
   {
     $(".consulta").show();
     $(".txt_busca").show();
     $(".texto1").show();
     $(".label_busca").show();
     $(".txt_busca").val("").css("color","gray");

   });
});
