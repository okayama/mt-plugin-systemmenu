package SystemMenu::Callbacks;
use strict;

use MT::Util qw( encode_html );

sub _cb_ts_header {
    my ( $cb, $app, $tmpl ) = @_;
    return if $app->param( 'blog_id' ) && $app->param( 'blog_id' ) eq 0;
    my $plugin = MT->component( 'SystemMenu' );
    my $r = $app->registry( 'applications', 'cms', 'menus' );
    my $list;
    if ( $plugin->get_config_value( 'show_list_website' ) ) {
        my $condition = $app->handler_to_coderef( $r->{ 'website:manage' }->{ condition } );
        if ( $condition->() ) {
            $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list&amp;_type=website&amp;blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="Websites"></a></li>' . "\n";
        }
    }
    if ( $plugin->get_config_value( 'show_list_blog' ) ) {
        my $condition = $app->handler_to_coderef( $r->{ 'blog:manage' }->{ condition } );
        if ( $condition->() ) {
            $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list&amp;_type=website&amp;blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="Blogs"></a></li>' . "\n";
        }
    }
    if ( $plugin->get_config_value( 'show_list_user' ) && $app->user->can_do( 'access_to_system_author_list' ) ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list&amp;_type=author&amp;blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="Users"></a></li>' . "\n";
    }
    if ( $plugin->get_config_value( 'show_list_templates' ) && $app->user->can_do( 'edit_templates' ) ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list_template&amp;blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="Templates"></a></li>' . "\n";
    }
    if ( $plugin->get_config_value( 'show_cfg_plugins' ) && $app->user->can_do( 'manage_plugins' ) ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=cfg_plugins&amp;blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="Plugins"></a></li>' . "\n";
    }
    if ( $plugin->get_config_value( 'show_view_log' ) && $app->user->can_do( 'view_log' ) ) {
        $list .= '<li><a href="<$mt:var name="mt_url">?__mode=list&amp;_type=log&amp;blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="System Activity Feed"></a></li>' . "\n";
    }
    if ( $list ) {
        my $insert = <<'CSS';
<style type="text/css">
    #selector-nav #system-menu-list {
        border-top:1px solid #DBDCDC;
    }
    #selector-nav #system-menu-list a:hover {
        background-color: #7F8081;
    }
</style>
CSS
        $insert .= '<mt:unless name="scope_type" eq="system">' . "\n";
        $insert .= '<ul id="system-menu-list">' . "\n";
        $insert .= '   <li><span class="sticky-label scope-level system"><__trans phrase="System Overview"></span>' . "\n";
        $insert .= '       <ul>' . "\n";
        if ( $plugin->get_config_value( 'show_dashboard' ) ) {
            $insert .= '           <li><a href="<$mt:var name="mt_url">?blog_id=0&amp;return_args=<$mt:var name="return_args" escape="url"$>"><__trans phrase="Dashboard"></a></li>' . "\n";
        }
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
