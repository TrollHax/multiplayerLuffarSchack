/**
 * The networking class contains functions
 * for everything related to networking
 * between the host and client
 *
 * @author  Reymond T
 * @version 1.0
 * @since   2022-04-10
 */

class Networking {

  Server thisPc;
  Client clientPc;
  String outgoing, incoming;

  Networking() {
    outgoing = "";
    incoming = "";
  }

  //Function for creating a host computer
  void createHost() {
    thisPc = new Server(luffarSchack.this, 25565);
    thisGame.gameServer = thisPc;
  }

  //Function for creating a client computer
  void createClient(String IP) {
    clientPc = new Client(luffarSchack.this, IP, 25565);
    thisGame.gameClient = clientPc;
  }

  //Function for getting ip of host computer
  String getIP() {
    InetAddress inet;
    String myIP;

    try {
      inet = InetAddress.getLocalHost();
      myIP = inet.getHostAddress();
    }
    catch (Exception e) {
      e.printStackTrace();
      myIP = "couldnt get IP";
    }
    return(myIP);
  }
}
