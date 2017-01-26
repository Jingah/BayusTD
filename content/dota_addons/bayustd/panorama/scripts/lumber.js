"use strict";

function OnPlayerLumberChanged ( args ) {
	var iPlayerID = Players.GetLocalPlayer()
	var lumber = args.lumber
	$.Msg("Player "+iPlayerID+" Lumber: "+lumber)
	$('#LumberText').text = lumber
}

(function () {
	GameEvents.Subscribe( "cgm_player_lumber_changed", OnPlayerLumberChanged );
	
	
	$("#LumberPanel").SetPanelEvent(
	  "onmouseover", 
	  function(){
		$.DispatchEvent("DOTAShowTextTooltip", $("#LumberPanel"), "Lumber used to build towers");
	  }
	)
	$("#LumberPanel").SetPanelEvent(
	  "onmouseout", 
	  function(){
		$.DispatchEvent("DOTAHideTextTooltip");
	  }
	)
})();