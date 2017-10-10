package com.jamwix.hs.tutorial;

import com.jamwix.hs.ui.popups.PopupDoc;
import com.jamwix.utils.IntPoint;

// Holds a single criteria for a tutorial step, such as "matched >= 3 gems" or "clicked on something"
class TutorialStepCriteria 
{
	static public var REL_GTE:Int = 0;
	static public var REL_GT:Int = 1;
	static public var REL_LTE:Int = 2;
	static public var REL_LT:Int = 3;
	static public var REL_EQUAL:Int = 4;

	public var criteriaType:Int;	// the type of criteria. Mandatory
	public var criteriaArg:Int;		// (optional) additional argument to the criteria, such as card ID or gem type
	public var criteriaRel:Int;		// the relationship that needs to exist between the current value and the argument
									// for this criteria to have been met

	public function new(data:Array<Int>)
	{
		criteriaType = data[0];

		criteriaArg = -1;
		criteriaRel = -1;

		if (data.length > 1)
		{
			criteriaArg = data[1];
			criteriaRel = data[2];
		}
	}
}

// holds all of the information for a given tutorial step
class TutorialStepData
{
	private var _startFunc:Void->Void;	// (optional) function to run at start of step
	private var _endFunc:Void->Void;	// (optional) function to run at end of step
	private var _preText:String;		// (optional) text to display at start
	private var _postText:String;		// (optional) text to display at end
	private var _criteria:Array<TutorialStepCriteria>;	// the criteria that defines what's needed to move to the next step
	private var _pointAt:IntPoint;

	public var stage:Int;
	public var step:Int;
	public var hasPause:Bool;

	public function new(s:Int, st:Int, ?criteriaIn:Array<Array<Int>> = null,
						?sFunc:Void->Void = null, 
						?sText:String = '', 
						?eFunc:Void->Void=null, 
						?eText:String = '',
						?pointAt:IntPoint = null)
	{
		stage = s;
		step = st;
		hasPause = false;

		_startFunc = sFunc;
		_preText = sText;
		_endFunc = eFunc;
		_postText = eText;

		_pointAt = pointAt;



		_criteria = new Array<TutorialStepCriteria>();

		if (criteriaIn != null)
		{
			var c:TutorialStepCriteria;
			for (i in 0...criteriaIn.length)
			{
				c = new TutorialStepCriteria(criteriaIn[i]);
				_criteria.push(c);
			
				if (c.criteriaType == TutorialManager.CRIT_PAUSE_MILLIS)
				{
					hasPause = true;
				}
			}
		}

	}

	// Check all the criteria for this step and return false if any of them
	// are not yet met.
	public function isComplete(currCriteria:Map<Int, Int>):Bool
	{
		var currVal:Int;
		var cmpVal:Int;

		if (_criteria == null || _criteria.length < 1) 
		{
			return false;
		}
		for (i in 0..._criteria.length)
		{	
			// check to make sure the criteria has been set
			if (currCriteria.exists(_criteria[i].criteriaType) == false)
			{
				return false;
			}

			// if a criteria with an argument, check it too
			if (_criteria[i].criteriaArg != -1 && _criteria[i].criteriaRel != -1)
			{
				currVal = currCriteria.get(_criteria[i].criteriaType);
				cmpVal = _criteria[i].criteriaArg;

				switch (_criteria[i].criteriaRel)
				{
					case TutorialStepCriteria.REL_EQUAL:
					{
						if (currVal != cmpVal)
						{
							return false;
						}
					}
					case TutorialStepCriteria.REL_GTE:
					{
						if (currVal < cmpVal)
						{
							return false;
						}
					}
					case TutorialStepCriteria.REL_GT:
					{
						if (currVal <= cmpVal)
						{
							return false;
						}
					}
					case TutorialStepCriteria.REL_LTE:
					{
						if (currVal > cmpVal)
						{
							return false;
						}
					}
					case TutorialStepCriteria.REL_LT:
					{
						if (currVal >= cmpVal)
						{
							return false;
						}
					}
				}
			}		
		}
		
		// made it through everything w/out failing, all criteria have been met
		trace('CRIT PASSED');
		return true;
	}

	public function start():Void
	{
		trace('STARTING : ' + stage + ',' + step);
		if (_startFunc != null)
		{
			trace('RUNNING START FUNC FOR ' + stage + ',' + step);
			_startFunc();
		}
		// make sure that the doc popup doesn't hide the arrow
		var corner:Int = PopupDoc.CORNER_BOTRIGHT;

		if (_preText != null && _preText != '')
		{
			trace('ADDING DOC POPUP _preText ' + _preText);
			GameRegistry.popups.addDocPopup(_preText, corner, true, 40);
		}
	}

	public function end():Void
	{
		if (_endFunc != null)
		{
			_endFunc();
		}
	}
}
