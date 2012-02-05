package game.Events {
	import flash.events.Event;

	public class SceneEvent extends Event{

		public static const WANT_REMOVE:String = "wantRemove";
		public function SceneEvent(type:String) {
			super(type);
		}
	}
}
