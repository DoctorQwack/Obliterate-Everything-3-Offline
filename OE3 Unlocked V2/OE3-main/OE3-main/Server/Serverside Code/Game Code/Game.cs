using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using PlayerIO.GameLibrary;
using System.Drawing;

namespace OE3 {

	public class Player : BasePlayer {
        public int mcount = 0;
        public bool checkedin = false;
        public bool armoryin = false;
        public bool ready = false;
        public bool auth = false;
        public int currentmission = -1;
        public string username = "";
        public string password = "";
        public int[] armory = new int[150];
        public int[] results = new int[4];
        public DatabaseObject db;
		public Player() {

		}
	}

	[RoomType("Game")]
	public class GameCode : Game<Player> {
		public int[] rmove = new int[12];
        public int[] arm = new int[4*(15+6)*3];
        public int clock = 0;
        public int state = 0;
        public int playermax = 2;
        public int[] hashes = new int[4];
        public int freezecounter = 0;
        public bool victoryflag = false; //Once one result received, freeze game
        public string[] playernames = new string[4];
        public int[] ratings = new int[4];
        public int prizemode = 1;

		public override void GameStarted() {

			Console.WriteLine("Game is started");

			AddTimer(delegate {
                int i = 0;
                int j = 0;
                int k = 0;
                int cc = 0;
                int cs = 0;
                //PREGAME
                if (state < 10)
                {
                    freezecounter++;
                    if (freezecounter > 60)
                    {
                        foreach (Player p in Players)
                        {
                            p.Disconnect();
                        }
                    }
                }
                if (state == 0)
                {
                    i = 0;
                    foreach (Player p in Players)
                    {
                        if (p.auth == true)
                        {
                            i++;
                        }
                    }
                    if (i == playermax)
                    {
                        state = 1;
                        freezecounter = 0;
                        Message m = Message.Create("grstats");
                        i = 0;
                        foreach (Player p in Players)
                        {
                            m.Add(p.db.GetString("callsign"));
                            if (p.db.GetInt("wins") + p.db.GetInt("losses") > 4)
                            {
                                m.Add(p.db.GetInt("rating"));
                            }
                            else
                            {
                                m.Add(0);
                            }
                            i++;
                        }
                        Broadcast(m);
                    }
                }
                //CHECK FOR ARMORY DATA
                if (state == 1)
                {
                    i = 0;
                    foreach (Player p in Players)
                    {
                        i++;
                    }
                    if (i == playermax && CheckArmory() == 1)
                    {
                        Message m = Message.Create("grarmory");
                        for (i = 0; i < playermax; i++)
                        {
                            for (j = 0; j < 21; j++)
                            {
                                for (k = 0; k < 4; k++)
                                {
                                    m.Add(arm[i * (21 * 4) + 4 * j + k]);
                                }
                            }
                        }
                        
                        Broadcast(m);
                        state = 2;
                        freezecounter = 0;
                    }
                }
                if (state == 2)
                {
                    i = 0;
                    foreach (Player p in Players)
                    {
                        i++;
                    }
                    if (i == playermax && CheckReady() == 1)
                    {
                        StartGame();
                        freezecounter = 0;
                    }
                }
                //GAME
                if (state == 10)
                {
                    if (clock < 2)
                    {
                        foreach (Player p in Players)
                        {
                            for (i = 0; i < p.results.Length; i++)
                            {
                                p.results[i] = -1;
                            }
                        }
                    }
                    freezecounter++;
                    cc = CheckClean();
                    cs = CheckSync();
                    if (cc == 1 && (cs == 0 && clock > 10))
                    {
                        Message m = Message.Create("gdesync");
                        Broadcast(m);
                    }
                    if (cc == 1 && (cs == 1 || clock == 0) && victoryflag == false)
                    {
                        Message m = Message.Create("gupdate");

                        clock = clock + 1;
                        m.Add(clock);

                        //ADD MOVES
                        i = 0;
                        for (i = 0; i < playermax; i++)
                        {
                            j = 0;
                            foreach (Player p in Players)
                            {
                                if (p.Id - 1 == i)
                                {
                                    m.Add(rmove[i * 3]);
                                    m.Add(rmove[i * 3 + 1]);
                                    m.Add(rmove[i * 3 + 2]);
                                    j = 1;
                                }
                            }
                            if (j == 0) //Disconnected Player
                            {
                                m.Add(0);
                                m.Add(0);
                                m.Add(0);
                            }
                        }

                        Broadcast(m);
                        freezecounter = 0;
                        foreach (Player p in Players)
                        {
                            p.checkedin = false;
                        }
                    }
                    if (freezecounter == 30)
                    {
                        Message m = Message.Create("glag");
                        foreach (Player p in Players)
                        {
                            m.Add(p.checkedin);
                            i++;
                        }
                        Broadcast(m);
                    }
                    if (freezecounter > 100)
                    {
                        foreach (Player p in Players)
                        {
                            if (p.checkedin == false)
                            {
                                foreach (Player pp in Players)
                                {
                                    p.results[pp.Id - 1] = 9;
                                }
                                p.Disconnect();
                            }
                        }
                    }
                }
			}, 100);

		}

		public override void GameClosed() {
			Console.WriteLine("RoomId: " + RoomId);
		}

		public override void UserJoined(Player player) {

			Message m = Message.Create("ginit");

			m.Add(player.Id);

			player.Send(m);

		}

		public override void UserLeft(Player player) {
            int i = 0;
			Console.WriteLine("Player " + player.Id + " left the room");

			Broadcast("gleft", player.Id);

            foreach (Player p in Players)
            {
                p.results[player.Id - 1] = 9;
                i++;
            }
            if (playermax == 2 && i == 2 && prizemode == 1)
            {
                    if (player.auth == true)
                    {
                        player.db.Set("losses", player.db.GetInt("losses") + 1);
                        int ra = 0;
                        int rb = 0;
                        int v = 30;
                        double e;
                        if (player.Id == 1)
                        {
                            ra = ratings[0];
                            rb = ratings[1];
                        }
                        if (player.Id == 2)
                        {
                            ra = ratings[1];
                            rb = ratings[0];
                        }
                        if (player.db.GetInt("wins") + player.db.GetInt("losses") < 6)
                        {
                            v = 100;
                        }
                        e = 1 / (1 + Math.Pow(10, ((rb - ra) / 400)));
                        player.db.Set("rating", (int)(player.db.GetInt("rating") + v * (player.results[player.Id - 1] - e)));
                        player.db.Save(null);
                    }
            }
		}

		public override void GotMessage(Player player, Message message) {
			//Switch on message type
            uint i = 0;
            uint j = 0;
            uint k = 0;
            bool endcheck = false;
			switch(message.Type) {
                case "glogin":
                    player.username = message.GetString(0);
                    player.password = message.GetString(1);
                    
                    int jj;
                    int kk;

                    PlayerIO.BigDB.Load("PlayerObjects", player.username, delegate(DatabaseObject result)
                    {
                        if (result != null)
                        {
                            if (result.GetString("password") == player.password)
                            {
                                playernames[player.Id - 1] = player.username;
                                ratings[player.Id - 1] = result.GetInt("rating");
                                DatabaseArray eq = result.GetArray("equip");
                                DatabaseArray aa = result.GetArray("armory");

                                for (jj = 0; jj < eq.Count; jj++)
                                {
                                    if (eq.GetInt(jj) >= 0)
                                    {
                                        DatabaseArray ab = aa.GetArray(eq.GetInt(jj));
                                        for (kk = 0; kk < 4; kk++)
                                        {
                                            arm[((player.Id - 1) * 21 * 4) + 4 * jj + kk] = ab.GetInt(kk);
                                        }
                                    }
                                    else
                                    {
                                        arm[((player.Id - 1) * 21 * 4) + 4 * jj + 0] = -1;
                                        arm[((player.Id - 1) * 21 * 4) + 4 * jj + 1] = -1;
                                        arm[((player.Id - 1) * 21 * 4) + 4 * jj + 2] = -1;
                                        arm[((player.Id - 1) * 21 * 4) + 4 * jj + 3] = -1;
                                    }
                                }
                                player.armoryin = true;
                                player.auth = true;
                                player.db = result;
                            }
                        }
                    });
                    break;
				case "gcheckin":
                    rmove[(player.Id - 1) * 3] = message.GetInteger(0);
                    rmove[(player.Id - 1) * 3 + 1] = message.GetInteger(1);
                    rmove[(player.Id - 1) * 3 + 2] = message.GetInteger(2);
                    hashes[player.Id - 1] = message.GetInteger(3);
                    player.checkedin = true;
					break;
                case "gprivate":
                    prizemode = 0;
                    break;
                case "graid":
                    prizemode = 0;
                    playermax = 4;
                    break;
                case "garmory":
                    player.armoryin = true;
                    for (i = 0; i < message.Count; i++)
                    {
                        arm[((player.Id - 1) * 21 * 4) + i] = message.GetInteger(i);
                        //CHANGE TO DATABASE COORDINATES
                    }
                    break;
                case "gready":
                    player.ready = true;
                    break;
                case "ggameover":
                    victoryflag = true;
                    for (i = 0; i < message.Count; i++)
                    {
                        player.results[i] = message.GetInteger(i);
                    }
                    endcheck = true;
                    foreach (Player p in Players)
                    {
                        foreach (Player pp in Players)
                        {
                            if (p.results[pp.Id - 1] == -1)
                            {
                                endcheck = false;
                            }
                        }
                    }
                    if(endcheck == true){
                        foreach (Player p in Players)
                        {
                            foreach (Player pp in Players)
                            {
                                if (p.results[pp.Id - 1] != pp.results[pp.Id - 1])
                                {
                                    endcheck = false;
                                }
                                if (pp.results[p.Id - 1] != p.results[p.Id - 1])
                                {
                                    endcheck = false;
                                }
                            }
                        }
                        if (endcheck == true)
                        {
                            foreach (Player p in Players)
                            {
                                Message prize = Message.Create("prize");
                                Message m = Message.Create("gresult");
                                m.Add(p.results[p.Id - 1]);
                                p.Send(m);

                                if (p.auth == true && prizemode == 1)
                                {
                                    if (p.results[p.Id - 1] == 1)
                                    {
                                        p.db.Set("wins", p.db.GetInt("wins") + 1);
                                        if (p.db.GetDateTime("lasttime").Day == DateTime.UtcNow.Day)
                                        {
                                            p.db.Set("winstoday", p.db.GetInt("winstoday") + 1);
                                        }
                                        else
                                        {
                                            p.db.Set("winstoday", 0);
                                        }
                                    }
                                    if (p.results[p.Id - 1] == 0)
                                    {
                                        p.db.Set("losses", p.db.GetInt("losses") + 1);
                                    }
                                    if (playermax == 2)
                                    {
                                        int ra = 0;
                                        int rb = 0;
                                        int v = 30;
                                        double e;
                                        if (p.Id == 1)
                                        {
                                            ra = ratings[0];
                                            rb = ratings[1];
                                        }
                                        if (p.Id == 2)
                                        {
                                            ra = ratings[1];
                                            rb = ratings[0];
                                        }
                                        e = 1 / (1 + Math.Pow(10, ((rb - ra)/400)));
                                        if (p.db.GetInt("wins") + p.db.GetInt("losses") < 6)
                                        {
                                            v = 100;
                                        }
                                        p.db.Set("rating", (int)(p.db.GetInt("rating") + v * (p.results[p.Id - 1] - e)));
                                        if (p.results[p.Id - 1] == 1)
                                        {
                                            Random randomreward = new Random();
                                            /*if(randomreward.Next(0,100) < 30){
                                                prize.Add(1);
                                                prize.Add((int)(10 + 150 * (p.results[p.Id - 1] - e)));
                                                p.db.Set("credits", (int)(p.db.GetInt("credits") + (int)(10 + 40 * (p.results[p.Id - 1] - e))));
                                                p.Send(prize);
                                            }else{*/
                                            int addplat = 2;
                                            prize.Add(2);
                                            prize.Add(addplat);
                                            PayVault vv = p.PayVault;
                                            vv.Credit((uint)(addplat), "victory", delegate()
                                            {
                                                
                                            });

                                            p.Send(prize);
                                        }
                                    }
                                    p.db.Save(null);
                                }
                            }
                            //DoResults();
                            foreach (Player p in Players)
                            {
                                p.Disconnect();
                            }
                        }
                    }
                    break;
			}
		}

        public int CheckArmory()
        {
            int checking = 1;
            foreach (Player p in Players)
            {
                if (p.armoryin == false)
                {
                    checking = 0;
                }
            }
            return (checking);
        }

        public int CheckReady()
        {
            int checking = 1;
            foreach (Player p in Players)
            {
                if (p.ready == false)
                {
                    checking = 0;
                }
            }
            return (checking);
        }

        public int CheckClean()
        {
            int checking = 1;
            foreach(Player p in Players) {
                if (p.checkedin == false)
                {
                    checking = 0;
                }
            }
            return (checking);
        }

        public int CheckSync()
        {
            int checking = 1;
            int i;
            int j;
            /*for (i = 1; i < playermax; i++)
            {
                if(hashes[i] != hashes[i-1]){
                    checking = 0;
                }
            }*/
            j = -1;
            foreach (Player p in Players)
            {
                i = p.Id - 1;
                if (j > -1)
                {
                    if (hashes[i] != hashes[j])
                    {
                        checking = 0;
                    }
                }
                j = i;
            }
            return checking;
        }

        /*public void DoResults()
        {
            int i;
            for(i = 0; i < playermax; i++)
            {
                if (playernames[i] != "")
                {
                    PlayerIO.BigDB.Load("PlayerObjects", playernames[i], delegate(DatabaseObject result)
                    {
                        if (result != null)
                        {
                            Player p = new Player();
                            foreach (Player pp in Players)
                            {
                                p.results = pp.results;
                            }
                            if (p.results[i] == 1)
                            {
                                result.Set("wins", result.GetInt("wins") + 1);
                            }
                            if (p.results[i] == 0)
                            {
                                result.Set("losses", result.GetInt("losses") + 1);
                            }
                            result.Save(null);
                        }
                    });
                }
            }
        }*/

        public void StartGame()
        {
            Random r = new Random();
            int l = r.Next(0, 5);
            Broadcast("ggo",l);
            freezecounter = 0;
            state = 10;
        }
	}

    [RoomType("Matcher")]
    public class MatchCode : Game<Player>
    {
        public int clock = 0;
        public int state = 0;
        public int playermax = 2;

        public override void GameStarted()
        {

            Console.WriteLine("Matching is started");

            AddTimer(delegate
            {
                uint i = 0;
                uint j = 0;
                string room;

                foreach (Player p in Players)
                {
                    i++;
                }
                if (i >= playermax)
                {
                    j = 0;
                    room = randomString(10);
                    foreach (Player p in Players)
                    {
                        if (j < 2)
                        {
                            p.Send("mgo", room);
                            j++;
                        }
                    }
                }
            }, 1000);

        }

        /*public override void UserJoined(Player player)
        {
            uint i = 0;
            uint j = 0;
            string room;

            foreach (Player p in Players)
            {
                i++;
            }
            if (i >= playermax)
            {
                j = 0;
                room = randomString(10);
                foreach (Player p in Players)
                {
                    if (j < 2)
                    {
                        p.Send("mgo", room);
                        j++;
                    }
                }
                i = 0;
                foreach (Player p in Players)
                {
                    i++;
                }
            }
        }*/

        private static string randomString(int length)
        {
            string allowedChars = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789";
            char[] chars = new char[length+4];
            Random random = new Random();

            chars[0] = 'G';
            chars[1] = 'a';
            chars[2] = 'm';
            chars[3] = 'e';
            for (int i = 4; i < length+4; i++)
            {
                chars[i] = allowedChars[random.Next(0, allowedChars.Length)];
            }

            return new string(chars);
        }
    }

    [RoomType("Service")]
    public class ServiceCode : Game<Player>
    {
        public DatabaseObject prices;
        public DatabaseObject vault;
        public DatabaseObject packs;
        public int vaultminute = -1;
        public int vaulthour = -1;
        public int maxstations = 7;

        public int broken = 0;

        public override void GameStarted()
        {

            Console.WriteLine("Service is started");

            PlayerIO.BigDB.Load("Prices", "List", delegate(DatabaseObject result)
            {
                if (result != null)
                {
                    prices = result;
                }
            });

            PlayerIO.BigDB.Load("Vault", "List", delegate(DatabaseObject result)
            {
                if (result != null)
                {
                    vault = result;
                }
            });

            PlayerIO.BigDB.Load("Packs", "List", delegate(DatabaseObject result)
            {
                if (result != null)
                {
                    packs = result;
                }
            });

            AddTimer(delegate
            {
                if (vault != null && DateTime.UtcNow.Second < 1)
                {
                    CheckVault();
                }
                if (DateTime.UtcNow.Minute < 1)
                {
                    foreach (Player p in Players)
                    {
                        SetStations(p, p.db);
                    }
                }
                foreach (Player p in Players)
                {
                    if (p.mcount > 0)
                    {
                        p.mcount = p.mcount - 1;
                    }
                }
                CheckBroken();
            }, 100);
        }

        public void CheckBroken()
        {
            if (broken == 1)
            {
                Message m = Message.Create("sreboot");
                Broadcast(m);
                foreach (Player p in Players)
                {
                    p.Disconnect();
                }
            }
        }

        public override void GameClosed()
        {
            Console.WriteLine("RoomId: " + RoomId);
        }

        public override void UserJoined(Player player)
        {
            
        }

        public override void UserLeft(Player player)
        {

        }

        public void NewAccount(Player player, Message message)
        {
            int i = 0;
            player.username = message.GetString(0);
            player.password = message.GetString(1);

            DatabaseObject obj = new DatabaseObject();
            obj.Set("username", player.username);
            obj.Set("callsign", player.username);
            obj.Set("password", player.password);
            obj.Set("credits", 500);
            obj.Set("stations", maxstations);
            obj.Set("maxinventory", 50);
            obj.Set("starttime", DateTime.UtcNow);
            obj.Set("lasttime", DateTime.UtcNow);
            obj.Set("laststations", DateTime.UtcNow);
            obj.Set("lastbonus", DateTime.UtcNow);
            obj.Set("wins", 0);
            obj.Set("winstoday", 0);
            obj.Set("losses", 0);
            obj.Set("rating", 1000);
            obj.Set("classlock", 0);
            obj.Set("class", 0);
            obj.Set("campaignseed", 0);
            obj.Set("campaignstart", -1);

            DatabaseArray arr = new DatabaseArray();
            for (i = 0; i < 50; i++)
            {
                DatabaseArray arrb = new DatabaseArray();
                arrb.Add(-1);
                arrb.Add(-1);
                arrb.Add(-1);
                arrb.Add(-1);
                arr.Add(arrb);
            }
            obj.Set("armory", arr);
            player.db = obj;
            AddItem(player, 100, -1, -1, -1);
            AddItem(player, 101, -1, -1, -1);
            AddItem(player, 102, -1, -1, -1);
            AddItem(player, 200, -1, -1, -1);
            AddItem(player, 202, -1, -1, -1);
            AddItem(player, 250, -1, -1, -1);

            arr = new DatabaseArray();
            for (i = 0; i < 21; i++)
            {
                arr.Add(-1);
            }
            obj.Set("equip", arr);
            obj.Set("equip.0", 3);
            obj.Set("equip.1", 4);
            obj.Set("equip.3", 5);
            obj.Set("equip.8", 0);
            obj.Set("equip.9", 1);
            obj.Set("equip.10", 2);

            arr = new DatabaseArray();
            for (i = 0; i < 36; i++)
            {
                arr.Add(0);
            }
            obj.Set("campaign", arr);

            arr = new DatabaseArray();
            for (i = 0; i < 36; i++)
            {
                DatabaseArray arrb = new DatabaseArray();
                arrb.Add(-1);
                arrb.Add(-1);
                arrb.Add(-1);
                arrb.Add(-1);
                arr.Add(arrb);
            }
            obj.Set("prizes", arr);

            PlayerIO.BigDB.CreateObject("PlayerObjects", player.username, obj,
                delegate(DatabaseObject result)
                {
                    Message m = Message.Create("screated");
                    player.Send(m);
                    player.db = result;
                    SendAccount(player, player.db);
                    SendArmory(player, player.db);
                    SendEquip(player, player.db);
                    SendPrices(player, prices);
                    if (vault != null)
                    {
                        SendVault(player);
                    }
                    SendVaultClockB(player);
                    if (packs != null)
                    {
                        SendPacks(player);
                    }
                    player.auth = true;

                    GenCampaign(player, result, 0, true);
                    PayVault v = player.PayVault;
                    v.Credit(30, "New Player Bonus", delegate()
                    {
                        SendPlatinum(player);
                    });
                },
                delegate(PlayerIOError error)
                {
                    Message m = Message.Create("snametaken");
                    player.Send(m);
                    player.Disconnect();
                }
            );
        }

        public void Login(Player player, Message message)
        {
            player.username = message.GetString(0);
            player.password = message.GetString(1);

            PlayerIO.BigDB.Load("PlayerObjects", player.username, delegate(DatabaseObject result)
            {
                if (result != null)
                {
                    if (result.GetString("password") == player.password)
                    {
                        player.auth = true;
                        Message m = Message.Create("sloggedon");
                        player.Send(m);
                        player.db = result;
                        SetStations(player, player.db);
                        if (result.GetDateTime("lasttime").Day != DateTime.UtcNow.Day)
                        {
                            result.Set("winstoday", 0);
                        }
                        SendAccount(player, player.db);
                        SendArmory(player, player.db);
                        SendEquip(player, player.db);
                        SendCampaign(player, player.db);
                        SendPrices(player, prices);
                        if (vault != null)
                        {
                            SendVault(player);
                        }
                        SendVaultClockB(player);
                        if (packs != null)
                        {
                            SendPacks(player);
                        }

                        PayVault v = player.PayVault;
	                    v.Refresh(delegate(){
                            SendPlatinum(player);
	                    });

                        player.db.Set("lasttime", DateTime.UtcNow);
                        player.db.Save(null);
                    }
                }
            });
        }

        public override void GotMessage(Player player, Message message)
        {
            //Switch on message type
            uint i;
            Message mm;
            if (player.mcount < 40)
            {
                player.mcount = player.mcount + 20;
            }
            if (player.mcount < 40 || message.Type == "sgameover")
            {
                switch (message.Type)
                {
                    case "stequip":
                        DatabaseArray eq = new DatabaseArray();
                        if (player.auth == true)
                        {
                            for (i = 0; i < message.Count; i++)
                            {
                                eq.Add(message.GetInt(i));
                            }
                            player.db.Set("equip", eq);
                            player.db.Save(null);
                        }
                        break;
                    case "snewcampaign":
                        if (player.auth == true)
                        {
                            if (message.GetInt(0) <= player.db.GetInt("classlock") && player.db.GetInt("stations") > 0)
                            {
                                GenCampaign(player, player.db, message.GetInt(0), true);

                                player.db.Set("stations", player.db.GetInt("stations") - 1);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                });
                            }
                        }
                        break;
                    case "screateaccount":

                        NewAccount(player, message);

                        break;
                    case "slogin":

                        Login(player, message);

                        break;
                    case "skong":
                        PlayerIO.BigDB.Load("PlayerObjects", message.GetString(0), delegate(DatabaseObject result)
                        {
                            if (result != null)
                            {
                                Login(player, message);
                            }
                            if (result == null)
                            {
                                NewAccount(player, message);
                            }
                        });
                        break;
                    case "sbuy":
                        if (player.auth == true)
                        {
                            Message m;
                            PayVault v = player.PayVault;
                            if (CheckFree(player, 1) == true)
                            {
                                DatabaseArray pp;
                                DatabaseArray vv;

                                bool okay = false;
                                int mult = 1;
                                vv = vault.GetArray(Convert.ToString(message.GetInt(0)));
                                pp = prices.GetArray(Convert.ToString(vv.GetInt(0) - 100));
                                if (vv.GetInt(1) > -1)
                                {
                                    mult = mult * 3;
                                }
                                if (vv.GetInt(2) > -1)
                                {
                                    mult = mult * 3;
                                }
                                if (vv.GetInt(3) > -1)
                                {
                                    mult = mult * 3;
                                }
                                if (message.GetInt(1) == 0 && player.db.GetInt("credits") >= mult * pp.GetInt(0))
                                {
                                    okay = true;
                                }
                                if (message.GetInt(1) == 1 && v.Coins >= mult * pp.GetInt(1))
                                {
                                    okay = true;
                                }
                                if (okay == true)
                                {
                                    AddItem(player, vv.GetInt(0), vv.GetInt(1), vv.GetInt(2), vv.GetInt(3));
                                    if (message.GetInt(1) == 0)
                                    {
                                        player.db.Set("credits", player.db.GetInt("credits") - (mult * pp.GetInt(0)));
                                    }
                                    player.db.Save(delegate()
                                    {
                                        if (message.GetInt(1) == 1)
                                        {
                                            //player.db.Set("platinum", player.db.GetInt("platinum") - (mult * pp.GetInt(1)));
                                            v.Debit((uint)(mult * pp.GetInt(1)), "buy item " + Convert.ToString(vv.GetInt(0)) + "," + Convert.ToString(vv.GetInt(1)) + "," + Convert.ToString(vv.GetInt(2)) + "," + Convert.ToString(vv.GetInt(3)), delegate()
                                            {
                                                SendPlatinum(player);
                                            });
                                        }
                                        SendAccount(player, player.db);
                                        SendArmory(player, player.db);
                                        m = Message.Create("sbought");
                                        player.Send(m);
                                    });
                                    if (mult > 3)
                                    {
                                        PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                        {
                                            if (result != null)
                                            {
                                                result.Set(Convert.ToString(15), result.GetInt(Convert.ToString(15)) + 1);

                                                result.Save();
                                            }
                                        });
                                    }
                                }
                            }
                            else
                            {
                                m = Message.Create("snospace");
                                player.Send(m);
                            }
                        }
                        break;
                    case "ssell":
                        if (player.auth == true)
                        {
                            DatabaseArray arm;
                            DatabaseArray b;
                            DatabaseArray e;
                            int j;
                            bool echange = false;
                            player.auth = true;
                            arm = player.db.GetArray("armory");
                            b = arm.GetArray(message.GetInteger(0));
                            if (b.GetInt(0) >= 0)
                            {
                                if (message.GetInteger(1) == 0)
                                {
                                    player.db.Set("credits", player.db.GetInt("credits") + (int)(Math.Ceiling(0.1 * GetCreditPrice(b.GetInt(0), b.GetInt(1), b.GetInt(2), b.GetInt(3)))));
                                }
                                else
                                {
                                    //player.db.Set("platinum", player.db.GetInt("platinum") + (int)(Math.Ceiling(0.1 * GetPlatinumPrice(b.GetInt(0), b.GetInt(1), b.GetInt(2), b.GetInt(3)))));
                                }
                                b.Set(0, -1);
                                b.Set(1, -1);
                                b.Set(2, -1);
                                b.Set(3, -1);
                                e = player.db.GetArray("equip");
                                for (j = 0; j < e.Count; j++)
                                {
                                    if (message.GetInteger(0) == e.GetInt(j))
                                    {
                                        e.Set(j, -1);
                                        echange = true;
                                    }
                                }
                                player.db.Save(true, true, delegate()
                                {
                                    SendAccount(player, player.db);
                                    SendArmory(player, player.db);
                                    if (echange == true)
                                    {
                                        SendEquip(player, player.db);
                                    }
                                    Message m = Message.Create("ssold");
                                    player.Send(m);
                                }, delegate(PlayerIOError error)
                                {
                                    broken = 1;
                                });
                            }
                        }
                        break;
                    case "srequestmission":
                        if (player.auth == true && player.db.GetInt("stations") > 0)
                        {
                            player.currentmission = message.GetInteger(0);
                            player.db.Set("stations", player.db.GetInt("stations") - 1);
                            player.db.Save(null);
                            mm = Message.Create("sstartmission");
                            player.Send(mm);
                        }
                        break;
                    case "sfixmission":
                        if (player.auth == true)
                        {
                            player.currentmission = message.GetInteger(0);
                        }
                        break;
                    case "sgameover":
                        DatabaseArray a;
                        if (player.auth == true && player.currentmission != -1)
                        {
                            int result = 0;
                            result = message.GetInt(0);
                            if (result == 1) //Victory
                            {
                                a = player.db.GetArray("campaign");
                                player.db.Set("stations", player.db.GetInt("stations") + 1);
                                if (player.currentmission != 1000)
                                {
                                    a.Set(player.currentmission, 2);
                                    MissionPrize(player);
                                }
                                if (player.currentmission == 1000)
                                {
                                    CompleteCampaign(player, player.db);
                                }
                            }
                            else
                            {

                            }
                            player.db.Save(delegate()
                            {
                                mm = Message.Create("sresultconfirmed", result);
                                player.Send(mm);
                                SendAccount(player, player.db);
                                SendPlatinum(player);
                                SendCampaign(player, player.db);
                                SendArmory(player, player.db);
                                SendEquip(player, player.db);
                            }, delegate(PlayerIOError error)
                            {
                                broken = 1;
                            });

                        }
                        break;
                    case "sbuystations":
                        if (player.auth == true)
                        {
                            PayVault v = player.PayVault;
                            int numstations = maxstations - player.db.GetInt("stations");
                            if (v.Coins >= 4 * numstations)
                            {
                                player.db.Set("stations", maxstations);
                                player.db.Save(delegate()
                                {
                                    v.Debit((uint)(4 * numstations), "buy lives", delegate()
                                    {
                                        SendPlatinum(player);
                                        SendAccount(player, player.db);
                                    });
                                });
                                PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                {
                                    if (result != null)
                                    {
                                        result.Set(Convert.ToString(14), result.GetInt(Convert.ToString(14)) + numstations);

                                        result.Save();
                                    }
                                });
                            }
                        }
                        break;
                    case "sbuycredits":
                        if (player.auth == true)
                        {
                            PayVault v = player.PayVault;
                            int cred = message.GetInt(0);
                            if (cred == 0 && v.Coins >= 1)
                            {

                                player.db.Set("credits", player.db.GetInt("credits") + 100);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                    v.Debit(1, "credits 100", delegate()
                                    {
                                        SendPlatinum(player);
                                    });
                                });
                                PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                {
                                    if (result != null)
                                    {
                                        result.Set(Convert.ToString(16), result.GetInt(Convert.ToString(16)) + 1);

                                        result.Save();
                                    }
                                });
                            }
                            if (cred == 1 && v.Coins >= 10)
                            {

                                player.db.Set("credits", player.db.GetInt("credits") + 1000);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                    v.Debit(10, "credits 1000", delegate()
                                    {
                                        SendPlatinum(player);
                                    });
                                });
                                PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                {
                                    if (result != null)
                                    {
                                        result.Set(Convert.ToString(17), result.GetInt(Convert.ToString(17)) + 1);

                                        result.Save();
                                    }
                                });
                            }
                            if (cred == 2 && v.Coins >= 50)
                            {

                                player.db.Set("credits", player.db.GetInt("credits") + 5000);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                    v.Debit(50, "credits 5000", delegate()
                                    {
                                        SendPlatinum(player);
                                    });
                                });
                                PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                {
                                    if (result != null)
                                    {
                                        result.Set(Convert.ToString(18), result.GetInt(Convert.ToString(18)) + 1);

                                        result.Save();
                                    }
                                });
                            }
                        }
                        break;
                    case "supdateplatinum":
                        PayVault vvv = player.PayVault;
                        vvv.Refresh(delegate()
                        {
                            SendPlatinum(player);
                        });
                        break;
                    case "sbuyplatinum":
                        if (player.auth == true)
                        {
                            /*PayVault v = player.PayVault;
                            int plat = message.GetInt(0);
                            if (plat == 0)
                            {
                                player.db.Set("platinum", player.db.GetInt("platinum") + 50);
                                player.db.Set("purchased", player.db.GetInt("purchased") + 50);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                });
                            }
                            if (plat == 1) 
                            {
                                player.db.Set("platinum", player.db.GetInt("platinum") + 110);
                                player.db.Set("purchased", player.db.GetInt("purchased") + 110);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                });
                            }
                            if (plat == 2)
                            {
                                player.db.Set("platinum", player.db.GetInt("platinum") + 250);
                                player.db.Set("purchased", player.db.GetInt("purchased") + 250);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                });
                            }
                            if (plat == 3)
                            {
                                player.db.Set("platinum", player.db.GetInt("platinum") + 700);
                                player.db.Set("purchased", player.db.GetInt("purchased") + 700);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                });
                            }
                            if (plat == 4)
                            {
                                player.db.Set("platinum", player.db.GetInt("platinum") + 1500);
                                player.db.Set("purchased", player.db.GetInt("purchased") + 1500);
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                });
                            }*/
                        }
                        break;
                    case "sbuyitempack":
                        if (player.auth == true)
                        {
                            PayVault v = player.PayVault;
                            DatabaseObject packdata = new DatabaseObject();
                            packdata = packs.GetObject(Convert.ToString(message.GetInt(0)));
                            if (v.Coins >= packdata.GetInt("price") && CheckFree(player, 5) == true)
                            {
                                DatabaseArray packdataitems = new DatabaseArray();

                                for (i = 0; i < 5; i++)
                                {
                                    packdataitems = packdata.GetArray(Convert.ToString(i));
                                    AddItem(player, packdataitems.GetInt(0), packdataitems.GetInt(1), packdataitems.GetInt(2), packdataitems.GetInt(3));
                                }
                                player.db.Save(delegate()
                                {
                                    SendArmory(player, player.db);
                                    v.Debit((uint)(packdata.GetInt("price")), "pack " + Convert.ToString(message.GetInt(0)), delegate()
                                    {
                                        SendPlatinum(player);
                                    });
                                });
                                PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                {
                                    if (result != null)
                                    {
                                        result.Set(Convert.ToString(message.GetInt(0) + 1), result.GetInt(Convert.ToString(message.GetInt(0) + 1)) + 1);

                                        result.Save();
                                    }
                                });
                            }
                        }
                        break;
                    case "sbuypack":
                        if (player.auth == true)
                        {
                            PayVault v = player.PayVault;
                            if (v.Coins >= 50)
                            {
                                player.db.Set("maxinventory", player.db.GetInt("maxinventory") + 10);
                                DatabaseArray packar;
                                for (i = 0; i < 10; i++)
                                {
                                    packar = player.db.GetArray("armory");
                                    DatabaseArray packarb = new DatabaseArray();
                                    packarb.Add(-1);
                                    packarb.Add(-1);
                                    packarb.Add(-1);
                                    packarb.Add(-1);
                                    packar.Add(packarb);
                                }
                                player.db.Save(delegate()
                                {
                                    SendAccount(player, player.db);
                                    SendArmory(player, player.db);
                                    v.Debit(50, "inventory", delegate()
                                    {
                                        SendPlatinum(player);
                                    });
                                });
                                PlayerIO.BigDB.Load("SalesData", "table", delegate(DatabaseObject result)
                                {
                                    if (result != null)
                                    {
                                        result.Set(Convert.ToString(13), result.GetInt(Convert.ToString(13)) + 1);

                                        result.Save();
                                    }
                                });
                            }
                        }
                        break;
                    case "sclaimprize":
                        if (player.auth == true && player.db.GetDateTime("lastbonus").Day != DateTime.UtcNow.Day)
                        {
                            PayVault v = player.PayVault;
                            Random rr = new Random();
                            int bonus = 10;
                            Message claimed = Message.Create("claimed");
                            claimed.Add(bonus);
                            player.Send(claimed);
                            player.db.Set("lastbonus", DateTime.UtcNow);
                            player.db.Save(delegate()
                            {
                                SendAccount(player, player.db);
                                v.Credit((uint)(bonus), "bonus", delegate()
                                {
                                    SendPlatinum(player);
                                });
                            });
                        }
                        break;
                    case "supgrade":
                        if (player.auth == true)
                        {
                            if (player.db.GetInt("credits") >= 750)
                            {
                                DatabaseArray arm;
                                DatabaseArray arma;
                                int seed;
                                int s;
                                Random random = new Random();
                                player.db.Set("credits", player.db.GetInt("credits") - 250);
                                arm = player.db.GetArray("armory");
                                arma = arm.GetArray(message.GetInt(0));
                                seed = random.Next(0, 900000000);
                                s = arma.GetInt(0);
                                arma.Set(0, s);
                                arma.Set(1, -1);
                                arma.Set(2, -1);
                                arma.Set(3, -1);
                                seed = random.Next(0, 900000000);
                                arma.Set(1, AppendUpgrade(s, seed));
                                if (random.Next(0, 100) > 40)
                                {
                                    seed = random.Next(0, 900000000);
                                    arma.Set(2, AppendUpgrade(s, seed));
                                    if (random.Next(0, 100) > 70)
                                    {
                                        seed = random.Next(0, 900000000);
                                        arma.Set(3, AppendUpgrade(s, seed));
                                    }
                                }
                                FixItem(arma);
                                player.db.Save(delegate()
                                {
                                    SendUpgrade(player, arma);
                                    SendAccount(player, player.db);
                                    SendArmory(player, player.db);
                                }, delegate(PlayerIOError error)
                                {
                                    broken = 1;
                                });
                            }
                        }
                        break;
                    case "scallsign":
                        if (player.auth == true)
                        {
                            player.db.Set("callsign", message.GetString(0));
                            player.db.Save();
                        }
                        break;
                    case "sping":
                        if (player.auth == true)
                        {
                            Message mping = Message.Create("srping");
                            player.Send(mping);
                        }
                        break;
                }
            }
        }

        public void AddItem(Player p, int a, int b, int c, int d)
        {
            int i;
            DatabaseArray arm;
            DatabaseArray armb;
            arm = p.db.GetArray("armory");
            for (i = 0; i < arm.Count; i++)
            {
                armb = arm.GetArray(i);
                if (armb.GetInt(0) == -1)
                {
                    armb.Set(0, a);
                    armb.Set(1, b);
                    armb.Set(2, c);
                    armb.Set(3, d);
                    i = arm.Count;
                }
            }
        }

        public bool CheckFree(Player p, int spots)
        {
            bool t = false;
            int spotsleft = spots;
            int i = 0;
            DatabaseArray arm;
            DatabaseArray armb;
            arm = p.db.GetArray("armory");
            for (i = 0; i < p.db.GetInt("maxinventory"); i++)
            {
                armb = arm.GetArray(i);
                if (armb.GetInt(0) == -1)
                {
                    spotsleft--;
                }
            }
            if (spotsleft <= 0)
            {
                t = true;
            }
            return t;
        }

        public void MissionPrize(Player p)
        {
            DatabaseArray prizesa;
            DatabaseArray prizesb;
            
            Random random = new Random();
            prizesa = p.db.GetArray("prizes");
            prizesb = prizesa.GetArray(p.currentmission);

            if (prizesb.GetInt(0) > 0 && prizesb.GetInt(0) < 1000)
            {
                Message prize = Message.Create("prize");
                AddItem(p, prizesb.GetInt(0), prizesb.GetInt(1), prizesb.GetInt(2), prizesb.GetInt(3));
                prize.Add(3);
                prize.Add(prizesb.GetInt(0));
                prize.Add(prizesb.GetInt(1));
                prize.Add(prizesb.GetInt(2));
                prize.Add(prizesb.GetInt(3));
                p.Send(prize);
            }
            if (prizesb.GetInt(0) > 1000)
            {
                MissionPrizeCredits(p, prizesb.GetInt(0) - 1000);
            }
            
            /*MissionPrizeCredits(p, 3 + difficulty.GetInt(p.currentmission) + random.Next(0, 10));
            MissionPrizePlatinum(p, 1 + difficulty.GetInt(p.currentmission) + random.Next(0, 2));*/
        }

        public void MissionPrizeCredits(Player p, int total)
        {
            Message prize = Message.Create("prize");
            prize.Add(1);
            prize.Add(total);
            prize.Add(0);
            prize.Add(0);
            prize.Add(0);
            p.db.Set("credits", p.db.GetInt("credits") +total);
            p.Send(prize);
        }

        public void MissionPrizePlatinum(Player p, int total)
        {
            Message prize = Message.Create("prize");
            prize.Add(2);
            prize.Add(total);
            prize.Add(0);
            prize.Add(0);
            prize.Add(0);
            p.Send(prize);
            PayVault v = p.PayVault;
            v.Credit((uint)(total), "boss", delegate()
            {
                SendPlatinum(p);
            });
        }

        public void SendUpgrade(Player player, DatabaseArray r)
        {
            Message m = Message.Create("supgraderesult", r.GetInt("0"), r.GetInt("1"), r.GetInt("2"), r.GetInt("3"));
            player.Send(m);
        }

        public void SendAccount(Player player, DatabaseObject r)
        {
            int bonus = 0;
            DateTime a;
            a = r.GetDateTime("lastbonus");
            if (a.Day != DateTime.UtcNow.Day)
            {
                bonus = 1;
            }
            Message m = Message.Create("sstats", r.GetInt("credits"), r.GetInt("stations"), r.GetInt("maxinventory"),bonus,r.GetInt("rating"),r.GetInt("wins"),r.GetInt("losses"));
            player.Send(m);
        }

        public void SendPlatinum(Player player)
        {
            PayVault v = player.PayVault;
            Message m = Message.Create("splat", v.Coins);
            player.Send(m);
        }

        public void SendCampaign(Player player,DatabaseObject r)
        {
            int i = 0;
            DatabaseArray a = new DatabaseArray();
            DatabaseArray b = new DatabaseArray();
            Message m = Message.Create("srcampaign");
            a = r.GetArray("campaign");
            m.Add(r.GetInt("campaignseed"));
            m.Add(r.GetInt("class"));
            m.Add(r.GetInt("classlock"));
            m.Add(r.GetInt("campaignstart"));
            for (i = 0; i < 6 * 6; i++)
            {
                m.Add(a.GetInt(i));
            }
            a = r.GetArray("prizes");
            for (i = 0; i < 6 * 6; i++)
            {
                b = a.GetArray(i);
                m.Add(b.GetInt(0));
                m.Add(b.GetInt(1));
                m.Add(b.GetInt(2));
                m.Add(b.GetInt(3));
            }
            player.Send(m);
        }

        public void SendArmory(Player player, DatabaseObject r)
        {
            int i = 0;
            int j = 0;
            
            Message m = Message.Create("srarmory");
            DatabaseArray a = r.GetArray("armory");
            for (i = 0; i < a.Count; i++)
            {
                DatabaseArray b = a.GetArray(i);
                for (j = 0; j < 4; j++)
                {
                    
                    m.Add(b.GetInt(j));
                }
            }
            player.Send(m);
        }

        public void SendEquip(Player player, DatabaseObject r)
        {
            int i = 0;
            int j = 0;

            Message m = Message.Create("srequip");
            DatabaseArray a = r.GetArray("equip");
            for (i = 0; i < a.Count; i++)
            {
                m.Add(a.GetInt(i));
            }
            player.Send(m);
        }

        public void SendPrices(Player player, DatabaseObject r)
        {
            int i = 0;
            int j = 0;

            Message m = Message.Create("srprices");
            for (i = 0; i < r.Count; i++)
            {
                DatabaseArray a = r.GetArray(Convert.ToString(i));
                for (j = 0; j < 2; j++)
                {
                    m.Add(a.GetInt(j));
                }
            }
            player.Send(m);
        }

        public void SendVault(Player player)
        {
            int i = 0;
            int j = 0;

            Message m = Message.Create("srvault");
            for (i = 0; i < vault.Count - 1; i++)
            {
                DatabaseArray a = vault.GetArray(Convert.ToString(i));
                for (j = 0; j < 4; j++)
                {
                    m.Add(a.GetInt(j));
                }
            }
            player.Send(m);
        }

        public void SendPacks(Player player)
        {
            int i = 0;
            int j = 0;
            int k = 0;

            Message m = Message.Create("srpacks");
            for (i = 0; i < packs.Count; i++)
            {
                DatabaseObject a = packs.GetObject(Convert.ToString(i));
                for (j = 0; j < 5; j++)
                {
                    DatabaseArray b = a.GetArray(Convert.ToString(j));
                    for (k = 0; k < 4; k++)
                    {
                        m.Add(b.GetInt(k));
                    }   
                }
                m.Add(a.GetInt("price"));
                m.Add(a.GetString("name"));
            }
            player.Send(m);
        }

        public void SetStations(Player player, DatabaseObject r)
        {
            int totalhours = 0;
            if (r != null)
            {
                if (r.GetInt("stations") < maxstations && (r.GetDateTime("laststations").Hour != DateTime.UtcNow.Hour || r.GetDateTime("laststations").Day != DateTime.UtcNow.Day))
                {
                    if (r.GetDateTime("laststations").Day != DateTime.UtcNow.Day)
                    {
                        totalhours = totalhours + 24;
                    }
                    totalhours = totalhours + DateTime.UtcNow.Hour - r.GetDateTime("laststations").Hour;
                    r.Set("stations", r.GetInt("stations") + totalhours);
                    if (r.GetInt("stations") > maxstations)
                    {
                        r.Set("stations", maxstations);
                    }
                    r.Set("laststations", DateTime.UtcNow);
                    r.Save(delegate()
                    {
                        SendAccount(player, r);
                    });
                }
            }
            
        }

        public void GenPrices()
        {
            int i;
            DatabaseArray a;
            DatabaseObject obj = new DatabaseObject();
            if (obj != null)
            {
                for (i = 0; i < 350; i++)
                {
                    a = new DatabaseArray();
                    a.Set(0, -1);
                    a.Set(1, -1);
                    obj.Set(Convert.ToString(i), a);
                }
            }

            PlayerIO.BigDB.CreateObject("Prices", "List", obj, null);
        }

        public void GenVault()
        {
            int i;
            DatabaseArray a;
            DatabaseObject obj = new DatabaseObject();
            if (obj != null)
            {
                for (i = 0; i < 12; i++)
                {
                    a = new DatabaseArray();
                    a.Set(0, -1);
                    a.Set(1, -1);
                    a.Set(2, -1);
                    a.Set(3, -1);
                    obj.Set(Convert.ToString(i), a);
                }
            }
            obj.Set("OldTime", (int)(DateTime.UtcNow.Hour));
            PlayerIO.BigDB.CreateObject("Vault", "List", obj, null);
        }

        public void GenPacks()
        {
            int i;
            int j;
            DatabaseArray a;
            DatabaseObject b = new DatabaseObject();
            DatabaseObject obj = new DatabaseObject();
            if (obj != null)
            {
                //FIX
                for (i = 0; i < 12; i++)
                {
                    b = new DatabaseObject();
                    b.Set("name", "");
                    b.Set("price", 50);
                    for (j = 0; j < 5; j++)
                    {
                        a = new DatabaseArray();
                        a.Set(0, -1);
                        a.Set(1, -1);
                        a.Set(2, -1);
                        a.Set(3, -1);
                        b.Set(Convert.ToString(j), a);
                    }
                    obj.Set(Convert.ToString(i), b);
                }
            }
            PlayerIO.BigDB.CreateObject("Packs", "List", obj, null);
        }

        /*public void CheckCampaign(Player p, DatabaseObject db)
        {
            int i;
            int j = 0;
            Boolean done = true;
            DatabaseArray a;
            a = db.GetArray("campaign");
            for (i = 0; i < a.Count; i++)
            {
                if (a.GetInt(i) == 1)
                {
                    done = false;
                }
            }
            if (done == true)
            {
                j = db.GetInt("classlock");
                if(db.GetInt("class") == j){
                    db.Set("classlock",j + 1);
                }
                GenCampaign(p, db, j+1,false);
            }
        }*/

        public void CompleteCampaign(Player p, DatabaseObject db)
        {
            int j = 0;
            int prize = 0;
            double a = 0;
            prize = 2 * db.GetInt("class") + 2;
            if (prize > 10)
            {
                a = prize - 10;
                prize = 10;
                a = a * .5;
                prize = 10 + (int)(a);
            }
            if (prize > 30)
            {
                prize = 30;
            }
            MissionPrizePlatinum(p, prize);
            j = db.GetInt("classlock");
            if (db.GetInt("class") == j)
            {
                db.Set("classlock", j + 1);
                GenCampaign(p, db, j + 1, false);
            }
            else
            {
                GenCampaign(p, db, db.GetInt("class") + 1, false);
            }
        }

        public void GenCampaign(Player p, DatabaseObject db, int dangerclass, Boolean save)
        {
            int i;
            int j;
            int gaps = 9;
            int timeout = 500;
            int rareodds = 75;
            bool safe = false;
            DatabaseArray c;
            DatabaseArray r;
            DatabaseArray a;
            int xx;
            int yy;
            int s = 0;
            int itemclass = 0;
            Random seed = new Random();
            c = db.GetArray("campaign");
            r = db.GetArray("prizes");
            db.Set("campaignseed",seed.Next(0,9999999));
            db.Set("class",dangerclass);
            //GEN MAP
            for (i = 0; i < 6 * 6; i++)
            {
                c.Set(i, 1);
            }

            //POKE HOLES
            while (gaps > 0 && timeout > 0)
            {
                xx = seed.Next(0,6);
                yy = seed.Next(0,6);
                safe = true;
                for (i = -1; i < 2; i++)
                {
                    for (j = -1; j < 2; j++)
                    {
                        if (xx + i >= 0 && xx + i <= 5 && yy + j >= 0 && yy + j <= 5)
                        {
                            if (c.GetInt(xx + i + (yy + j) * 6) == 0)
                            {
                                safe = false;
                            }
                        }
                    }
                }
                if (safe == true)
                {
                    c.Set(xx + yy * 6, 0);
                }
                timeout--;
            }
            
            timeout = 10;
            while (timeout > 0)
            {
                s = 0;
                j = 0;
                i = seed.Next(0, 20);
                while (j < i)
                {
                    if (j < 5)
                    {
                        s++;
                    }
                    if (j >= 5 && j < 10)
                    {
                        s = s + 6;
                    }
                    if (j >= 10 && j < 15)
                    {
                        s = s - 1;
                    }
                    if (j >= 15)
                    {
                        s = s - 6;
                    }
                    j++;
                }
                if (c.GetInt(s) == 1)
                {
                    timeout = 0;
                    db.Set("campaignstart", s);
                }
                timeout--;
            }
            if (db.GetInt("campaignstart") == -1)
            {
                for (i = 0; i < 6 * 6; i++)
                {
                    if (c.GetInt(i) == 1)
                    {
                        db.Set("campaignstart", i);
                        i = 100;
                    }
                }
            }

            //GEN PRIZES
            itemclass = 0;
            if (dangerclass == 0)
            {
                rareodds = 100;
                itemclass = 1;
            }
            if (dangerclass == 1)
            {
                rareodds = 80;
                itemclass = 2;
            }
            if (dangerclass > 9)
            {
                itemclass = 3;
            }
            if (dangerclass == 2)
            {
                rareodds = 75;
            }
            if (dangerclass == 3)
            {
                rareodds = 70;
            } 
            if (dangerclass > 3)
            {
                rareodds = 70 - 2 * (dangerclass-3);
            }
            for (i = 0; i < 6 * 6; i++)
            {
                a = r.GetArray(i);
                a.Set(0, GenRandomItem(itemclass, seed.Next(0, 999999999)));
                a.Set(1, -1);
                a.Set(2, -1);
                a.Set(3, -1);
                if (dangerclass > 0 && seed.Next(0, 100) > rareodds)
                {
                    a.Set(1, AppendUpgrade(a.GetInt(0), seed.Next(0, 999999999)));
                    if (dangerclass > 1 && seed.Next(0, 100) > 70)
                    {
                        a.Set(2, AppendUpgrade(a.GetInt(0), seed.Next(0, 999999999)));
                        if (dangerclass > 2 && seed.Next(0, 100) > 70)
                        {
                            a.Set(3, AppendUpgrade(a.GetInt(0), seed.Next(0, 999999999)));
                        }
                    }
                }
                if (seed.Next(0, 100) > 70)
                {
                    a.Set(0, Convert.ToInt32(1000 + 75 + 25 * dangerclass + seed.Next(0, 100)));
                    a.Set(1, -1);
                    a.Set(2, -1);
                    a.Set(3, -1);
                }
                FixItem(a);
            }

            if (save == true)
            {
                db.Save(delegate()
                {
                    SendCampaign(p, db);
                });
            }
        }

        public void CheckVault()
        {
            int a = 0;
            int b = 0;
            if (vault != null)
            {
                a = vault.GetInt("OldTime");
                b = (int)(DateTime.UtcNow.Hour);
                //if ( a + 1 < b || (b < 2 && a-24+1 < b && a > 21 ) || (b < a && b >= 2)) TWO HOURS
                if(a != b)
                {
                    SetVault();
                }

                SendVaultClock();
            }
        }

        public void SendVaultClock()
        {
            int a = 0;
            int b = 0;
            int c = 0;
            int d = 0;

            a = vault.GetInt("OldTime");
            b = (int)(DateTime.UtcNow.Hour);
            
            d = (a + 1) - b;
            if (d > 3)
            {
                d = (a + 1 - 24) - b;
            }

            c = (int)(DateTime.UtcNow.Minute);
            if (c != vaultminute)
            {
                Message m = Message.Create("svaultclock");
                vaultminute = c;
                d = 0;//SET TO ONE HOUR, DEFAULT IS TWO
                vaulthour = d; 
                m.Add(d, 60 - vaultminute);
                Broadcast(m);
            }
        }

        public void SendVaultClockB(Player p)
        {
            Message m = Message.Create("svaultclock");
            m.Add(vaulthour, 60 - vaultminute);
            p.Send(m);
        }

        public void SetVault()
        {
            int i;
            int j = 0;
            int k = 0;
            int s;
            int seed = 0;
            DatabaseArray a;
            DatabaseArray b;
            Random random = new Random();
            vault.Set("OldTime", (int)(DateTime.UtcNow.Hour));
            for (i = 0; i < vault.Count - 1; i++)
            {
                a = vault.GetArray(Convert.ToString(i));
                j = 0;
                while (j == 0)
                {
                    seed = random.Next(0, 900000000);
                    s = GenRandomItem(0, seed);
                    a.Set(0, s);
                    a.Set(1, -1);
                    a.Set(2, -1);
                    a.Set(3, -1);
                    j = 1;
                    for (k = 0; k < i; k++)
                    {
                        b = vault.GetArray(Convert.ToString(k));
                        if (a.GetInt(0) == b.GetInt(0))
                        {
                            j = 0;
                        }
                    }
                }
            }
            for (i = 0; i < vault.Count - 1; i++)
            {
                a = vault.GetArray(Convert.ToString(i));
                s = a.GetInt(0);
                if (random.Next(0, 10) > 2)
                {
                    seed = random.Next(0, 900000000);
                    a.Set(1,AppendUpgrade(s,seed));
                    if (random.Next(0, 10) > 2)
                    {
                        seed = random.Next(0, 900000000);
                        a.Set(2, AppendUpgrade(s,seed));
                        if (random.Next(0, 10) > 6)
                        {
                            seed = random.Next(0, 900000000);
                            a.Set(3, AppendUpgrade(s,seed));
                        }
                    }
                }
                FixItem(a);
            }
            vault.Save(true, true, delegate()
            {
                foreach (Player p in Players)
                {
                    SendVault(p);
                }
            }, delegate(PlayerIOError error)
            {
                PlayerIO.BigDB.Load("Vault", "List", delegate(DatabaseObject result)
                {
                    if (result != null)
                    {
                        vault = result;
                        foreach (Player p in Players)
                        {
                            SendVault(p);
                        }
                    }
                });
            });
        }

        public int GetCreditPrice(int a, int b, int c, int d)
        {
            int p = 0;
            DatabaseArray da;
            if ((a - 100) > -1 && (a - 100) < 350)
            {
                da = prices.GetArray(Convert.ToString(a-100));
                p = da.GetInt(0);
            }else{
                p = 0;
            }
            if (b >= 0)
            {
                p = p * 3;
            }
            if (c >= 0)
            {
                p = p * 3;
            }
            if (d >= 0)
            {
                p = p * 3;
            }
            return p;
        }

        public int GetPlatinumPrice(int a, int b, int c, int d)
        {
            int p = 0;
            DatabaseArray da;
            da = prices.GetArray(Convert.ToString(a-100));
            p = da.GetInt(1);
            if (b > 0)
            {
                p = p * 3;
            }
            if (c > 0)
            {
                p = p * 3;
            }
            if (d > 0)
            {
                p = p * 3;
            }
            return p;
        }

        public int GenRandomItem(int s, int seed)
        {
            int a = 0;
            int i = 0;
            int j = 0;
            Random random = new Random(seed);
            int[] items = new int[400];
            for (i = 0; i < items.GetLength(0); i++){
                items[i] = -1;
            }
            switch (s)
            {
                case 0: //VAULT
                    for (i = 100; i < 112; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 113; i < 115; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 116; i < 118; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 150; i < 151; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 152; i < 154; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 175; i < 184; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 200; i < 211; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 214; i < 216; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 250; i < 262; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 263; i < 266; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 300; i < 304; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 306; i < 309; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 311; i < 317; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 350; i < 361; i++)
                    {
                        if (random.Next(0, 100) > 50)
                        {
                            items[j] = i;
                            j++;
                        }
                    }
                    for (i = 361; i < 369; i++)
                    {
                        if(random.Next(0,100) > 90){
                            items[j] = i;
                            j++;
                        }
                    }
                    for (i = 369; i < 380; i++)
                    {
                        if (random.Next(0, 100) > 50)
                        {
                            items[j] = i;
                            j++;
                        }
                    }
                    break;
                case 1: //First Zone
                    for (i = 100; i < 112; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 113; i < 115; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 150; i < 151; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 175; i < 180; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 200; i < 211; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 250; i < 262; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 300; i < 303; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    break;
                case 2: //Second Zone
                    for (i = 100; i < 112; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 113; i < 115; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 150; i < 151; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 175; i < 182; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 200; i < 211; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 250; i < 262; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 300; i < 303; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 350; i < 361; i++)
                    {
                        if (random.Next(0, 100) > 50)
                        {
                            items[j] = i;
                            j++;
                        }
                    }
                    for (i = 369; i < 377; i++)
                    {
                        if (random.Next(0, 100) > 50)
                        {
                            items[j] = i;
                            j++;
                        }
                    }
                    break;
                case 3: //Tenth Zone
                    for (i = 100; i < 112; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 113; i < 115; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 116; i < 118; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 150; i < 152; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 152; i < 154; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 175; i < 184; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 200; i < 211; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 214; i < 216; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 250; i < 262; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 263; i < 266; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 300; i < 304; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 306; i < 309; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 310; i < 317; i++)
                    {
                        items[j] = i;
                        j++;
                    }
                    for (i = 350; i < 361; i++)
                    {
                        if (random.Next(0, 100) > 50)
                        {
                            items[j] = i;
                            j++;
                        }
                    }
                    for (i = 361; i < 369; i++)
                    {
                        if(random.Next(0,100) > 90){
                            items[j] = i;
                            j++;
                        }
                    }
                    for (i = 369; i < 380; i++)
                    {
                        if (random.Next(0, 100) > 50)
                        {
                            items[j] = i;
                            j++;
                        }
                    }
                    break;
            }
            a = items[random.Next(0, j)];
            return a;
        }

        public void FixItem(DatabaseArray a)
        {
            int i;
            int j;
            int sa;
            int sb;
            for(i = 2; i < 4; i++)
            {
                sa = a.GetInt(i);
                for (j = 1; j < 4; j++)
                {
                    if (j != i)
                    {
                        sb = a.GetInt(j);
                        if (sb == sa && sa != -1)
                        { //SAME MOD
                            sa = -1;
                            a.Set(i, -1);
                        }
                        if (sb > 0 && sb < 6 && sa > 0 && sa < 6)
                        { //TWO ENGINES LOL
                            sa = -1;
                            a.Set(i, -1);
                        }
                        if (sb > 5 && sb < 11 && sa > 5 && sa < 11)
                        { //TWO SHIELDS
                            sa = -1;
                            a.Set(i, -1);
                        }
                        if (sb > 10 && sb < 19 && sa > 10 && sa < 19)
                        { //TWO AMMO MODS
                            sa = -1;
                            a.Set(i, -1);
                        }
                        if (sb > 20 && sb < 37 && sa > 20 && sa < 37)
                        { //TWO HANGAR SHIP MODS
                            sa = -1;
                            a.Set(i, -1);
                        }
                    }
                }
                if (a.GetInt(0) >= 350)
                {
                    a.Set(1, -1);
                    a.Set(2, -1);
                    a.Set(3, -1);
                }
                if (a.GetInt(0) >= 175 && a.GetInt(0) < 200)
                {
                    a.Set(1, -1);
                    a.Set(2, -1);
                    a.Set(3, -1);
                }
            }
        }

        public int AppendUpgrade(int s, int seed)
        {
            int up = -1;
            int i;
            int j = 0;
            int[] u = new int[100];
            Random random = new Random(seed);
            for (i = 0; i < u.GetLength(0); i++)
            {
                u[i] = -1;
            }
            switch (AppendUpgradeClass(s))
            {
                case 0: //Turret General Class
                    j = 0;
                    for (i = 6; i < 19; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 52; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 1: //Turret Special Gun
                    j = 0;
                    for (i = 6; i < 11; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 52; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 8: //Fighter Special Gun
                    j = 0;
                    for (i = 1; i < 11; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 50; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 9: //Ship General Fighter Class
                    j = 0;
                    for (i = 1; i < 19; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 50; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 10: //Ship General Class
                    j = 0;
                    for (i = 1; i < 19; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 50; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 60; i < 61; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 11: //Ship Special Gun
                    j = 0;
                    for (i = 1; i < 11; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 50; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 60; i < 61; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 12: //Carrier
                    j = 0;
                    for (i = 1; i < 19; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 21; i < 29; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 37; i < 40; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 50; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
                case 13: //Special Carrier
                    j = 0;
                    for (i = 1; i < 19; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 37; i < 40; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 40; i < 50; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    for (i = 80; i < 81; i++)
                    {
                        u[j] = i;
                        j++;
                    }
                    break;
            }
            up = u[random.Next(0, j)];
            return up;
        }

        public int AppendUpgradeClass(int s)
        {
            int c = -1;
            //TURRETS
            if (s >= 100 && s < 175)
            {
                c = 0;
            }
            //TURRETS SPECIAL GUN
            if (s == 110 || s == 111 || s == 113 || s == 114 || s == 117 || s == 151 || s == 152 || s == 153)
            {
                c = 1;
            }
            //FIGHTERS
            if (s >= 200 && s < 250)
            {
                c = 9;
            }
            //SHIPS
            if (s >= 250 && s < 350)
            {
                c = 10;
            }
            //FIGHTERS SPECIAL GUN
            if (s == 204 || s == 205 || s == 209 || s == 210 || s == 215)
            {
                c = 8;
            }
            //SHIPS SPECIAL GUN
            if (s == 257 || s == 260 || s == 263 || s == 264 || s == 265 || s == 303 || s == 310 || s == 311 || s == 313)
            {
                c = 11;
            }
            //SHIPS CARRIER
            if (s == 252 || s == 256 || s == 301 || s == 302 || s == 308 || s == 312)
            {
                c = 12;
            }
            //SHIPS SPECIAL CARRIER
            if (s == 261 || s == 316)
            {
                c = 13;
            }
            return c;
        }
    }
}
