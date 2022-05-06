/**
 * The networking class contains functions
 * for everything related to networking
 * between the host and client
 *
 * @author  Reymond T
 * @version 1.2
 * @since   2022-04-10
 */

class Networking {

  Server thisServerPc;
  Client thisClientPc;
  String outgoing, incoming, pc;

  Networking(String _pc) {

    outgoing = "";
    incoming = "";
    pc = _pc;

    if (pc == "Host"){
      thisServerPc = new Server(luffarSchack.this, 25565);
    }
  }

  //Function for creating a client computer
  void createClient(String IP) {
    thisClientPc = new Client(luffarSchack.this, IP, 25565);
  }

  //Function for sending information to other player
  void sendData(String information) {
    if (pc == "Host") {
      thisServerPc.write(information);
    } else if (pc == "Client") {
      thisClientPc.write(information);
    }
  }

  //Function for reading information from other player
  String readData() {
    if (pc == "Host") {
      Client clientPc = thisServerPc.available();
      if (clientPc != null) {
        incoming = clientPc.readString();
      }
    } else if (pc == "Client") {
      if (thisClientPc.available() > 0) {
        incoming = thisClientPc.readString();
      }
    }
    return incoming;
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
