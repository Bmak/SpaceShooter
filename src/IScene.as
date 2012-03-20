package {
	
	/**
	 * Interface of SceneControlers
	 * @author BigMac
	 */
	public interface IScene {
		/*Open Scene*/
		function open():void;
		/*Close Scene, remove all objects*/
		function remove():void;
	}
}
