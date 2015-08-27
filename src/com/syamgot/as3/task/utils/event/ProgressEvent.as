package com.syamgot.as3.task.utils.event
{
	import flash.events.Event;
	
	public class ProgressEvent extends Event
	{
		public function ProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ProgressEvent(type, bubbles, cancelable);
		}
		
		public static const START:String = 'start';
		public static const COMPLETE:String = 'complete';
		public static const FAIL:String = 'fail';
		public static const PROGRESS:String = 'progress';
		public static const TIMEOUT:String = 'timeout';
	}
}