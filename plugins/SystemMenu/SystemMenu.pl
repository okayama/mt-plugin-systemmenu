package MT::Plugin::SystemMenu;
use strict;
use MT;
use MT::Plugin;
use base qw( MT::Plugin );

use MT::Util qw( encode_html );

our $VERSION = '1.0';

my $plugin = MT::Plugin::SystemMenu->new( {
    id => 'SystemMenu',
    key => 'systemmenu',
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    name => 'SystemMenu',
    author_name => 'okayama',
    author_link => 'http://weeeblog.net/',
    version => $VERSION,
    l10n_class => 'MT::SystemMenu::L10N',
} );
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry( {
        callbacks => {
            'MT::App::CMS::template_source.header'
                => \&_cb_ts_header,
        },
   } );
}

sub _cb_ts_header {
    my ( $cb, $app, $tmpl ) = @_;
    my $transform = 0;
    my $list;
    if ( $app->user->can_do( 'create_website' ) ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list_website&amp;blog_id=0&amp;<$mt:var name="return_args" escape="html"$>"><__trans phrase="Websites"></a></li>' . "\n";
    }
    if ( $app->user->is_superuser ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list_author&amp;blog_id=0&amp;<$mt:var name="return_args" escape="html"$>"><__trans phrase="Users"></a></li>' . "\n";
    }
    if ( $app->user->can_do( 'edit_templates' ) ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list_template&amp;blog_id=0&amp;<$mt:var name="return_args" escape="html"$>"><__trans phrase="Templates"></a></li>' . "\n";
    }
    if ( $app->user->can_manage_plugins ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=cfg_plugins&amp;blog_id=0&amp;<$mt:var name="return_args" escape="html"$>"><__trans phrase="Plugins"></a></li>' . "\n";
    }
    if ( $app->user->can_view_log ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=view_log&amp;blog_id=0&amp;<$mt:var name="return_args" escape="html"$>"><__trans phrase="System Activity Feed"></a></li>' . "\n";
    }
    if ( $list ) {
        my $insert = <<'CSS';
<style type="text/css">
    #selector-nav #system-menu-list {
        border-top:1px solid #9EA1A3;
    }
    #selector-nav #system-menu-list a {
        padding-left: 25px;
    }
    #selector-nav #system-menu-list a:hover {
        background-color: #5C909B;
    }
</style>
CSS
        $insert .= '<mt:unless name="scope_type" eq="system">' . "\n";
        $insert .= '<ul id="system-menu-list">' . "\n";
        $insert .= '   <li><span class="scope-lebel"><__trans phrase="System Overview"></span>' . "\n";
        $insert .= '       <ul>' . "\n";
        $insert .= '           <li><a href="<$mt:var name="mt_url">?blog_id=0&amp;<$mt:var name="return_args" escape="html"$>"><__trans phrase="Dashboard"></a></li>' . "\n";
        $insert .= $list;        
        $insert .= '       </ul>' . "\n";
        $insert .= '   </li>' . "\n";
        $insert .= '</ul>' . "\n";
        $insert .= '</mt:unless>' . "\n";
        my $search = quotemeta( '<mt:if name="fav_website_loop">' );
        if ( $$tmpl =~ s!($search)!$insert$1!s ) {
            $$tmpl =~ s!(<mt:unless name="scope_type" eq="system">).*?(</mt:unless>)!!s;
        }
    }
}

1;