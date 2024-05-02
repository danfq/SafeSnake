import 'package:safesnake/util/data/local.dart';

///Strings
class Strings {
  ///Get Current Lang
  static get currentLang => LocalData.boxData(box: "settings")["lang"] ?? "en";

  ///Set Current Lang
  static Future<void> setLang({required String lang}) async {
    await LocalData.updateValue(box: "settings", item: "lang", value: lang);
  }

  ///Page Titles
  static Map pageTitles = {
    "referral_add_code": {
      "en": "Add by Code",
      "pt": "Adicionar por Código",
    },
    "settings": {
      "en": "Settings",
      "pt": "Definições",
    },
  };

  ///Common
  static Map common = {
    "referral_code": {
      "en": "Referral Code",
      "pt": "Código de Referência",
    },
    "empty": {
      "en": "Looks like Tsuki needs to play by herself :(",
      "pt": "Parece que a Tsuki tem de brincar sozinha :(",
    },
    "or": {
      "en": "OR",
      "pt": "OU",
    },
  };

  ///Errors
  static Map errors = {
    "invalid_referral": {
      "en": "Invalid Referral Code",
      "pt": "Código de Referência Inválido",
    },
  };

  ///Settings
  static Map settings = {
    "ui": {
      "en": "UI & Visuals",
      "pt": "UI & Visuais",
    },
    "theme": {
      "en": "Theme",
      "pt": "Tema",
    },
    "dark_mode": {
      "en": "Dark Mode",
      "pt": "Modo Escuro",
    },
    "light_mode": {
      "en": "Light Mode",
      "pt": "Modo Claro",
    },
    "account": {
      "en": "Your Account",
      "pt": "A Tua Conta",
    },
    "account_info": {
      "en": "Information",
      "pt": "Informação",
    },
    "change_acc_info": {
      "en": "See and change all your Account Information.",
      "pt": "Vê e altera toda a tua Informação de Conta",
    },
    "accessibility": {
      "en": "Accessibility",
      "pt": "Acessibilidade",
    },
    "tts": {
      "en": "Text to Speech",
      "pt": "Narrador",
    },
    "tts_info": {
      "en": "Enables Text-to-Speech on Help Items & Messages.",
      "pt": "Ativa Narrador em Itens de Ajuda e Mensagens.",
    },
    "color_mode": {
      "en": "Colorful Mode",
      "pt": "Modo Colorido",
    },
    "color_mode_info": {
      "en": "Makes the App a lot more colorful!",
      "pt": "Faz a App muito mais colorida!",
    },
    "team_and_licenses": {
      "en": "Team & Licenses",
      "pt": "Equipa & Licenças",
    },
    "team": {
      "en": "Team",
      "pt": "Equipa",
    },
    "licenses": {
      "en": "Licenses",
      "pt": "Licenças",
    },
  };

  ///Help
  static Map help = {
    "notif_title": {
      "en": "Quick!",
      "pt": "Rápido!",
    },
    "notif_body": {
      "en": " needs you right now!",
      "pt": " precisa de ti agora!",
    },
    "notif_title_2": {
      "en": " needs your help!",
      "pt": " precisa da tua ajuda!",
    },
  };

  ///Loved Ones
  static Map lovedOnes = {
    "add": {
      "en": "Add Loved One",
      "pt": "Adicionar Loved One",
    },
    "urgent_contact": {
      "en": "Do you want to contact this Loved One urgently?",
      "pt": "Queres contactar este Loved One com urgência?",
    },
    "notify_all": {
      "en": "Notify All",
      "pt": "Notificar Todos",
    },
    "notified": {
      "en": "Notified!",
      "pt": "Notificado!",
    },
    "no_loved_ones": {
      "en": "You don't have any Loved Ones.",
      "pt": "Não tens Loved Ones.",
    },
    "invite": {
      "en": "Invite Loved Ones",
      "pt": "Convidar Loved Ones",
    },
    "enter_code": {
      "en": "Enter Code Manually",
      "pt": "Introduzir Código",
    },
  };

  ///Buttons
  static Map buttons = {
    "confirm": {
      "en": "Confirm",
      "pt": "Confirmar",
    },
    "swipe_confirm": {
      "en": "Swipe to Confirm",
      "pt": "Desliza para Confirmar",
    },
    "cancel": {
      "en": "Cancel",
      "pt": "Cancelar",
    },
    "delete_account": {
      "en": "Delete Account",
      "pt": "Apagar Conta",
    },
  };

  ///Intro Strings
  static Map intro = {
    "title_1": {
      "en": "Hi! I'm Corn!",
      "pt": "Olá! Sou a Corn!",
    },
    "body_1": {
      "en": "I will do my best to keep you safe.",
      "pt": "Farei o meu melhor para te manter seguro(a).",
    },
    "title_2": {
      "en": "Share Your Feelings",
      "pt": "Partilha os Teus Sentimentos",
    },
    "body_2": {
      "en": "Your Loved Ones can help too, of course.",
      "pt": "Os teus Loved Ones podem ajudar também, claro.",
    },
    "title_3": {
      "en": "Ask for Help",
      "pt": "Pede Ajuda",
    },
    "body_3": {
      "en": "There's no shame in it.\nWe all struggle sometimes!",
      "pt": "Não tenhas vergonha.\nTodos precisamos de ajuda, às vezes.",
    }
  };
}
